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

  val index_exists : string -> bool computation

  val create_index :
    ?shards: int ->
    ?replicas: int ->
    string -> Es_mapping.doc_mapping list ->
    unit computation

  val create_or_update_index :
    ?shards:int ->
    ?replicas:int ->
    string -> Es_mapping.doc_mapping list -> unit computation

  val delete_index : string -> unit computation

  val put_mapping :
    index: string -> Es_mapping.doc_mapping ->
    unit computation

  val put_mappings :
    index: string -> Es_mapping.doc_mapping list ->
    unit computation

  val get_mapping :
    index: string -> string ->
    string computation

  val get_item :
    index: string -> mapping: string -> doc_id ->
    item option computation

  val get_items :
    index: string -> mapping: string -> get_request_key list ->
    item list computation

  val index_item :
    ?parent_id: doc_id ->
    index: string -> mapping: string -> id: doc_id -> item: item -> unit ->
    unit computation

  val update_item :
    ?parent_id: doc_id ->
    index: string -> mapping: string -> id: doc_id -> item: item -> unit ->
    unit computation

  val delete_item :
    index: string -> mapping: string -> id: doc_id ->
    unit computation

  val all_indexes : string list
  val all_mappings : string list

  val default_sort : (string * sort_order) list
  val search :
    indexes: string list -> mappings: string list ->
    ?qid: string -> ?from: int -> ?size: int ->
    ?sort: (string * sort_order) list list ->
    Es_query.query ->
    item hit search_result computation

  val count :
    indexes: string list -> mappings: string list ->
    ?qid: string ->
    Es_query.query ->
    int computation
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

  let url_escape = Nlencoding.Url.encode

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

  (* take an http response and raise the most informative exception possible *)
  let raise_error = function
    | None -> raise Es_error.(Error Http_failure)
    | Some ((status, headers, body) as http_resp) ->
        let generic_result =
          try Some (Es_client_j.generic_result_of_string body)
          with _ -> None
        in
        match generic_result with
            None -> raise Es_error.(Error (Http_error http_resp))
          | Some x -> raise Es_error.(Error (Elasticsearch_error x))

  let is_acceptable_status accepted_statuses n =
    (n >= 200 && n < 300) || List.mem n accepted_statuses

  let has_error accepted_statuses status gen_resp =
    gen_resp.error <> None
    || not (is_acceptable_status accepted_statuses status)

  let read_body converter ((_, _, body) as http_resp) =
    try converter body
    with _ -> raise Es_error.(Error (Http_error http_resp))

  (*
    Take an optional http response, then
    raise the most informative exception possible if there's a problem,
    or return the http response.
    accept is a list of response status codes tolerated in
    addition to the 2xx range, such as 404 (not found).
  *)
  let check_generic_result ?(accept = []) = function
    | Some ((status, headers, body) as http_resp) ->
        let generic_result =
          try Some (Es_client_j.generic_result_of_string body)
          with _ -> None
        in
        (match generic_result with
            None -> raise Es_error.(Error (Http_error http_resp))
          | Some x ->
              if has_error accept status x then
                raise Es_error.(Error (Elasticsearch_error x))
              else
                return http_resp
        )
    | None ->
        raise Es_error.(Error Http_failure)

  (* handle the response for an operation that returns nothing
     (e.g. index a document, delete something, etc.)
  *)
  let handle_generic_result ?accept opt_http_resp =
    check_generic_result ?accept opt_http_resp >>= fun http_resp ->
    return ()

  let index_exists index =
    let uri = make_index_uri ~indexes:[index] "" in
    Http_client.head uri >>= fun res ->
    return (
      match res with
        | Some (200, _, _) -> true
        | Some (404, _, _) -> false
        | x -> raise_error x
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
    Http_client.put ~body uri >>= fun opt_resp ->
    handle_generic_result opt_resp

  let put_mapping ~index mapping =
    let uri =
      make_mapping_uri
        ~indexes: [index]
        ~mappings: [mapping.Es_mapping.doc_type]
        "_mapping"
    in
    let body = Es_mapping.to_json ~pretty:false mapping in
    Http_client.put ~body uri >>= fun opt_resp ->
    handle_generic_result opt_resp

  let rec list_iter f = function
    | [] -> return ()
    | x :: l ->
        f x >>= fun () -> list_iter f l

  let put_mappings ~index mappings =
    list_iter (put_mapping ~index) mappings

  let create_or_update_index ?shards ?replicas index mappings =
    index_exists index >>= function
      | true -> put_mappings ~index mappings
      | false -> create_index ?shards ?replicas index mappings

  let get_mapping ~index mapping =
    let uri =
      make_mapping_uri
        ~indexes: [index]
        ~mappings: [mapping]
        "_mapping"
    in
    Http_client.get uri >>= fun opt_resp ->
    check_generic_result opt_resp >>= fun (_, _, body) ->
    return body

  let delete_index index =
    let uri = make_index_uri ~indexes: [index] "" in
    Http_client.delete uri >>= fun opt_resp ->
    handle_generic_result opt_resp

  let get_item ~index ~mapping id =
    let uri =
      make_mapping_uri ~indexes: [index] ~mappings: [mapping] id in
    Http_client.get uri >>= fun opt_resp ->
    check_generic_result ~accept:[404] opt_resp >>= fun http_resp ->
    let conv =
      Es_client_j.get_result_of_string (Item.read ~doc_type:mapping)
    in
    let x = read_body conv http_resp in
    if x.gr_exists then
      return x.gr_source
    else
      return None

  let filter_map f l =
    let rec aux f acc = function
      | [] -> List.rev acc
      | x :: l ->
          let acc =
            match f x with
                None -> acc
              | Some y -> y :: acc
          in
          aux f acc l
    in
    aux f [] l

  let get_items ~index ~mapping keys =
    if keys = [] then
      return []
    else
      let uri =
        make_mapping_uri ~indexes: [index] ~mappings: [mapping] "_mget"
      in
      let body = Es_client_j.string_of_get_request { grq_docs = keys } in
      Http_client.post ~body uri >>= fun opt_resp ->
      check_generic_result opt_resp >>= fun http_resp ->
      let conv =
        Es_client_j.get_results_of_string (Item.read ~doc_type:mapping)
      in
      let results = read_body conv http_resp in
      let docs = filter_map (fun x -> x.gr_source) results.grs_docs in
      return docs

  let index_item ?parent_id ~index ~mapping ~id ~item () =
    let uri =
      make_mapping_uri ?parent_id
        ~indexes: [index] ~mappings: [mapping] id in
    let item_str = string_of_item item in
    Http_client.post ~body:item_str uri >>= fun opt_resp ->
    handle_generic_result opt_resp

  let update_item ?parent_id ~index ~mapping ~id ~item () =
    let uri =
      make_mapping_uri ?parent_id
        ~indexes: [index] ~mappings: [mapping] (id ^ "/_update") in
    let body =
      Es_client_j.string_of_update_request Item.write { ur_doc = item }
    in
    Http_client.post ~body uri >>= fun opt_resp ->
    handle_generic_result opt_resp

  let delete_item ~index ~mapping ~id =
    let uri =
      make_mapping_uri ~indexes: [index] ~mappings: [mapping] id in
    Http_client.delete uri >>= fun opt_resp ->
    handle_generic_result ~accept:[404] opt_resp

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
                    raise Es_error.(
                      Error (Data_error
                               "Es_client.decode_hit: malformed _type")
                    )
              )
            with Not_found ->
              raise Es_error.(
                Error (Data_error "Es_client.decode_hit: missing _type")
              )
          in
          let json_string = Yojson.Basic.to_string ast in
          (try
             Es_client_j.hit_of_string (Item.read ~doc_type) json_string
           with e ->
             let s = Printexc.to_string e in
             raise Es_error.(Error (Data_error ("Es_client.decode_hit: " ^ s)))
          )
      | _ ->
          raise Es_error.(
            Error (Data_error "Es_client.decode_hit: not an object")
          )

  let default_sort = [ "_score", { order = `Desc; ignore_unmapped = None } ]

  let search ~indexes ~mappings ?qid ?(from = 0) ?(size = 10) ?sort query =
    let q =
      Es_client_v.create_query_request
        ~query: (Es_query.to_json_ast ~cst_score:false query)
        ~from ~size ~track_scores:true ?sort ()
    in
    let body = Es_client_j.string_of_query_request q in
    let uri = make_mapping_uri ?qid ~indexes ~mappings "_search" in
    Http_client.post uri ~body >>= fun opt_resp ->
    check_generic_result opt_resp >>= fun http_resp ->
    let result =
      read_body (Es_client_j.search_result_of_string decode_hit) http_resp
    in
    return result

  let count ~indexes ~mappings ?qid query =
    let query = Es_query.to_json_ast ~cst_score:false query in
    let body = Yojson.Basic.to_string query in
    let uri = make_mapping_uri ?qid ~indexes ~mappings "_count" in
    Http_client.post uri ~body >>= fun opt_resp ->
    check_generic_result opt_resp >>= fun http_resp ->
    let search_result =
      read_body (Es_client_j.search_result_of_string decode_hit) http_resp
    in
    return search_result.sr_count
end
