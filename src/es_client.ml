open Printf
open Es_client_t

type uri = string
type response = (int * (string * string) list * string)

module type Http_client =
sig
  type 'a computation
  val bind : 'a computation -> ('a -> 'b computation) -> 'b computation
  val return : 'a -> 'a computation
  val head :
    ?headers:(string * string) list ->
    uri -> response option computation
  val get :
    ?headers:(string * string) list ->
    uri -> response option computation
  val post :
    ?headers:(string * string) list ->
    ?body:string ->
    uri -> response option computation
  val delete :
    ?headers:(string * string) list ->
    uri -> response option computation
  val put :
    ?headers:(string * string) list ->
    ?body:string ->
    uri -> response option computation
end

module Sync =
struct
  type 'a computation = 'a
  let bind x f = f x
  let return x = x
end

module type Server_address =
sig
  val host : unit -> string
  val port : unit -> int
end

module Default_address : Server_address =
struct
  let host () = "127.0.0.1"
  let port () = 9200
end

module type Json_serializable =
sig
  type t
  val read : doc_type:string -> Yojson.Safe.lexer_state -> Lexing.lexbuf -> t
  val write : Bi_outbuf.t -> t -> unit
end

module type Client =
sig
  type 'a computation
  type item
  type doc_id = string

  val index_exists : string -> bool option computation

  val create_index :
    ?shards: int ->
    ?replicas: int ->
    string -> Es_mapping.doc_mapping list ->
    simplified_result option computation

  val create_or_update_index :
    ?shards:int ->
    ?replicas:int ->
    string -> Es_mapping.doc_mapping list -> bool computation

  val delete_index :
    string -> simplified_result option computation

  val put_mapping :
    index: string -> Es_mapping.doc_mapping ->
    simplified_result option computation

  val put_mappings :
    index: string -> Es_mapping.doc_mapping list ->
    bool computation

  val get_mapping :
    index: string -> string ->
    string option computation

  val get_item :
    index: string -> mapping: string -> doc_id ->
    item get_result option computation

  val get_items :
    index: string -> mapping: string -> get_request_key list ->
    item get_results option computation

  val get_items_simple :
    index: string -> mapping: string -> get_request_key list ->
    item list computation

  val index_item :
    ?parent_id: doc_id ->
    index: string -> mapping: string -> id: doc_id -> item: item -> unit ->
    index_result option computation

  val update_item :
    ?parent_id: doc_id ->
    index: string -> mapping: string -> id: doc_id -> item: item -> unit ->
    update_result option computation

  val delete_item :
    index: string -> mapping: string -> id: doc_id ->
    delete_result option computation

  val all_indexes : string list
  val all_mappings : string list

  val default_sort : (string * sort_order) list
  val search :
    indexes: string list -> mappings: string list ->
    ?qid: string -> ?from: int -> ?size: int ->
    ?sort: (string * sort_order) list list ->
    Es_query.query ->
    item Es_client_t.hit search_result option computation

  val count :
    indexes: string list -> mappings: string list ->
    ?qid: string ->
    Es_query.query ->
    item Es_client_t.hit search_result option computation

end


module Make
  (Http_client : Http_client)
  (Server : Server_address)
  (Item : Json_serializable) :
  Client with type 'a computation = 'a Http_client.computation
          and type item = Item.t =
struct

  type 'a computation = 'a Http_client.computation
  type item = Item.t
  type doc_id = string

  open Http_client
  let (>>=) = Http_client.bind

  let string_of_item x =
    let ob = Bi_outbuf.create 2048 in
    Item.write ob x;
    Bi_outbuf.contents ob

  let url_escape = Netencoding.Url.encode

  let url_escape_list l =
    String.concat "," (List.map url_escape l)

  let make_index_uri ~indexes path =
    Printf.sprintf "http://%s:%d/%s/%s"
      (Server.host ()) (Server.port ())
      (url_escape_list indexes) path

  let make_mapping_uri ?parent_id ?qid ~indexes ~mappings path =
    let param =
      (match parent_id with
          None -> []
        | Some s -> ["parent", s])
      @ (match qid with
          None -> []
        | Some s ->
            (* for logging purposes only - ignored by elasticsearch *)
            ["qid", s])
    in
    let opt_query =
      match param with
          [] -> ""
        | l ->
            "?" ^ String.concat "&"
              (List.map (fun (k, v) -> url_escape k ^ "=" ^ url_escape v) l)
    in
    Printf.sprintf "http://%s:%d/%s/%s/%s%s"
      (Server.host ()) (Server.port ())
      (url_escape_list indexes) (url_escape_list mappings) path
      opt_query

  let handle_simplified_result = function
    | Some (status, headers, res) ->
        return
          (Some (Es_client_j.simplified_result_of_string res))
    | None ->
        return None

  let handle_string = function
    | Some (status, headers, res) ->
        return (Some res)
    | None ->
        return None

  let index_exists index =
    let uri = make_index_uri ~indexes:[index] "" in
    Http_client.head uri >>= fun res ->
    return (
      match res with
        | None -> None
        | Some (200, _, _) -> Some true
        | Some (404, _, _) -> Some false
        | _ -> None
    )

  let create_index ?shards ?replicas index mappings =
    let uri = make_index_uri ~indexes:[index] "" in
    let json_mappings =
      List.map
        (fun x ->
          (x.Es_mapping.doc_type, Es_mapping.to_json_ast x))
        mappings
    in
    let body =
      Es_client_j.string_of_create_index_request {
        settings = Some { number_of_shards = shards;
                          number_of_replicas = replicas };
        mappings = json_mappings;
      }
    in
    Http_client.put ~body uri
    >>= handle_simplified_result

  let put_mapping ~index mapping =
    let uri =
      make_mapping_uri
        ~indexes: [index]
        ~mappings: [mapping.Es_mapping.doc_type]
        "_mapping"
    in
    let body = Es_mapping.to_json ~pretty:false mapping in
    Http_client.put ~body uri
    >>= handle_simplified_result


  let is_ok x =
    match x.error with
        None -> true
      | Some _ -> false

  let put_mappings ~index mappings =
    List.fold_left (
      fun acc mapping ->
        acc >>= function
          | false -> return false
          | true ->
              put_mapping ~index mapping >>= function
                | None -> return false
                | Some x -> return (is_ok x)
    ) (return true) mappings

  let create_or_update_index ?shards ?replicas index mappings =
    index_exists index >>= function
      | None -> return false
      | Some true -> put_mappings ~index mappings
      | Some false ->
          (create_index ?shards ?replicas index mappings >>= function
            | None -> return false
            | Some x -> return (is_ok x)
          )

  let get_mapping ~index mapping =
    let uri =
      make_mapping_uri
        ~indexes: [index]
        ~mappings: [mapping]
        "_mapping"
    in
    Http_client.get uri
    >>= handle_string

  let delete_index index =
    let uri = make_index_uri ~indexes: [index] "" in
    Http_client.delete uri
    >>= handle_simplified_result

  let get_item ~index ~mapping id =
    let uri =
      make_mapping_uri ~indexes: [index] ~mappings: [mapping] id in
    Http_client.get uri
    >>= function
      | Some (status,hdrs,res) ->
          let x =
            Es_client_j.get_result_of_string (Item.read ~doc_type:mapping) res
          in
        return (Some x)
      | None ->
        return None

  let get_items ~index ~mapping keys =
    if keys = [] then
      return (Some {
        grs_docs = Some [];
        grs_error = None;
        grs_status = None;
      })
    else
      let uri =
        make_mapping_uri ~indexes: [index] ~mappings: [mapping] "_mget"
      in
      let body = Es_client_j.string_of_get_request { grq_docs = keys } in
      Http_client.post ~body uri >>= function
        | Some (status,hdrs,res) ->
            let results =
              Es_client_j.get_results_of_string
                (Item.read ~doc_type:mapping) res
            in
            return (Some results)
        | None ->
            return None

  let get_items_simple ~index ~mapping keys =
    let error s =
      let msg = sprintf "Es_client.get_items_simple: %s" s in
      failwith msg
    in
    get_items ~index ~mapping keys  >>= function
      | None -> error "TCP Error"
      | Some x ->
          match x.grs_error with
            | Some s -> error (sprintf "elasticsearch error: %s" s)
            | None ->
                match x.grs_status with
                  | Some n when n <> 200 ->
                      error (sprintf "elasticsearch error status %i" n)
                  | _ ->
                      let profiles =
                        match x.grs_docs with Some p -> p | _ -> [] in
                      return (BatList.filter_map (fun p -> p.gr_item) profiles)

  let index_item ?parent_id ~index ~mapping ~id ~item () =
    let uri =
      make_mapping_uri ?parent_id
        ~indexes: [index] ~mappings: [mapping] id in
    let item_str = string_of_item item in
    Http_client.post ~body:item_str uri
    >>= function
      | Some (status,hdrs,res)->
        return (Some (Es_client_j.index_result_of_string res))
      | None -> return None

  let update_item ?parent_id ~index ~mapping ~id ~item () =
    let uri =
      make_mapping_uri ?parent_id
        ~indexes: [index] ~mappings: [mapping] (id ^ "/_update") in
    let body =
      Es_client_j.string_of_update_request Item.write { ur_doc = item }
    in
    Http_client.post ~body uri
    >>= function
      | Some (status,hdrs,res)->
        return (Some (Es_client_j.update_result_of_string res))
      | None -> return None

  let delete_item ~index ~mapping ~id =
    let uri =
      make_mapping_uri ~indexes: [index] ~mappings: [mapping] id in
    Http_client.delete uri
    >>= function
      | Some (status,hdrs,res)->
        return (Some (Es_client_j.delete_result_of_string res))
      | None -> return None

  let all_indexes = ["*"]
  let all_mappings = ["*"]

  let decode_hit ls lb =
    let ast = Yojson.Basic.from_lexbuf ~stream:true ls lb in
    match ast with
        `Assoc l ->
          let doc_type =
            try
              (match List.assoc "_type" l with
                  `String s -> s
                | _ ->
                    failwith "Es_client.decode_hit: malformed _type")
            with Not_found -> failwith "Es_client.decode_hit: missing _type"
          in
          let json_string = Yojson.Basic.to_string ast in
          Es_client_j.hit_of_string (Item.read ~doc_type) json_string
      | _ ->
          failwith "Es_client.decode_hit: not an object"

  let default_sort = [ "_score", { order = `Desc; ignore_unmapped = None } ]

  let search ~indexes ~mappings ?qid ?(from = 0) ?(size = 10) ?sort query =
    let q =
      Es_client_v.create_query_request
        ~query: (Es_query.to_json_ast ~cst_score:false query)
        ~from ~size ~track_scores:true ?sort ()
    in
    let body = Es_client_j.string_of_query_request q in
    let uri = make_mapping_uri ?qid ~indexes ~mappings "_search" in
    Http_client.post uri ~body
    >>= function
      | Some (status, headers, res)->
        return (Some (Es_client_j.search_result_of_string decode_hit res))
      | None ->
        return None

  let count ~indexes ~mappings ?qid query =
    let query = Es_query.to_json_ast ~cst_score:false query in
    let body = Yojson.Basic.to_string query in
    let uri = make_mapping_uri ?qid ~indexes ~mappings "_count" in
    Http_client.post uri ~body
    >>= function
      | Some (status, headers, res)->
        return (Some (Es_client_j.search_result_of_string decode_hit res))
      | None ->
        return None

end
