(* Auto-generated from "es_client.atd" *)


type json = Es_untyped_json.json

type simplified_result = Es_client_t.simplified_result = {
  error: string option;
  status: int option
}

type index_settings = Es_client_t.index_settings = {
  number_of_shards: int option;
  number_of_replicas: int option
}

type create_index_request = Es_client_t.create_index_request = {
  settings: index_settings option;
  mappings: (string * json) list
}

type order = Es_client_t.order

type sort_order = Es_client_t.sort_order = {
  order: order;
  ignore_unmapped: bool option
}

type query_request = Es_client_t.query_request = {
  query: json;
  from: int;
  size: int;
  sort: (string * sort_order) list list option;
  track_scores: bool
}

type 'hit hits = 'hit Es_client_t.hits = {
  hts_total (*atd total *): int;
  hts_max_score (*atd max_score *): float option;
  hts_hits (*atd hits *): 'hit list
}

type shards = Es_client_t.shards = {
  sd_total (*atd total *): int;
  sd_successful (*atd successful *): int;
  sd_failed (*atd failed *): int
}

type 'hit search_result = 'hit Es_client_t.search_result = {
  sr_took (*atd took *): int option;
  sr_timed_out (*atd timed_out *): bool option;
  sr_shards: shards option;
  sr_hits (*atd hits *): 'hit hits option;
  sr_error (*atd error *): string option;
  sr_status (*atd status *): int option
}

type 'item get_result = 'item Es_client_t.get_result = {
  gr_id: string option;
  gr_index: string option;
  gr_type: string option;
  gr_version: int option;
  gr_exists (*atd exists *): bool option;
  gr_item: 'item option;
  gr_error (*atd error *): string option;
  gr_status (*atd status *): int option
}

type get_request_key = Es_client_t.get_request_key = {
  grq_id (*atd id *): string;
  grq_routing (*atd routing *): string option
}

type get_request = Es_client_t.get_request = {
  grq_docs (*atd docs *): get_request_key list
}

type 'item get_results = 'item Es_client_t.get_results = {
  grs_docs (*atd docs *): 'item get_result list option;
  grs_error (*atd error *): string option;
  grs_status (*atd status *): int option
}

type delete_result = Es_client_t.delete_result = {
  dr_id: string option;
  dr_index: string option;
  dr_type: string option;
  dr_version: int option;
  dr_found (*atd found *): bool option;
  dr_ok (*atd ok *): bool option;
  dr_error (*atd error *): string option;
  dr_status (*atd status *): int option
}

type index_result = Es_client_t.index_result = {
  ir_id: string option;
  ir_index: string option;
  ir_type: string option;
  ir_version: int option;
  ir_ok (*atd ok *): bool option;
  ir_error (*atd error *): string option;
  ir_status (*atd status *): int option
}

type 'item update_request = 'item Es_client_t.update_request = {
  ur_doc (*atd doc *): 'item
}

type update_result = Es_client_t.update_result = {
  ur_id: string option;
  ur_index: string option;
  ur_type: string option;
  ur_version: int option;
  ur_ok (*atd ok *): bool option;
  ur_error (*atd error *): string option;
  ur_status (*atd status *): int option
}

type 'item hit = 'item Es_client_t.hit = {
  ht_id: string;
  ht_index: string;
  ht_type: string;
  ht_score: float;
  ht_item: 'item
}

val write_json :
  Bi_outbuf.t -> json -> unit
  (** Output a JSON value of type {!json}. *)

val string_of_json :
  ?len:int -> json -> string
  (** Serialize a value of type {!json}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_json :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> json
  (** Input JSON data of type {!json}. *)

val json_of_string :
  string -> json
  (** Deserialize JSON data of type {!json}. *)

val write_simplified_result :
  Bi_outbuf.t -> simplified_result -> unit
  (** Output a JSON value of type {!simplified_result}. *)

val string_of_simplified_result :
  ?len:int -> simplified_result -> string
  (** Serialize a value of type {!simplified_result}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_simplified_result :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> simplified_result
  (** Input JSON data of type {!simplified_result}. *)

val simplified_result_of_string :
  string -> simplified_result
  (** Deserialize JSON data of type {!simplified_result}. *)

val write_index_settings :
  Bi_outbuf.t -> index_settings -> unit
  (** Output a JSON value of type {!index_settings}. *)

val string_of_index_settings :
  ?len:int -> index_settings -> string
  (** Serialize a value of type {!index_settings}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_index_settings :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> index_settings
  (** Input JSON data of type {!index_settings}. *)

val index_settings_of_string :
  string -> index_settings
  (** Deserialize JSON data of type {!index_settings}. *)

val write_create_index_request :
  Bi_outbuf.t -> create_index_request -> unit
  (** Output a JSON value of type {!create_index_request}. *)

val string_of_create_index_request :
  ?len:int -> create_index_request -> string
  (** Serialize a value of type {!create_index_request}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_create_index_request :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> create_index_request
  (** Input JSON data of type {!create_index_request}. *)

val create_index_request_of_string :
  string -> create_index_request
  (** Deserialize JSON data of type {!create_index_request}. *)

val write_order :
  Bi_outbuf.t -> order -> unit
  (** Output a JSON value of type {!order}. *)

val string_of_order :
  ?len:int -> order -> string
  (** Serialize a value of type {!order}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_order :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> order
  (** Input JSON data of type {!order}. *)

val order_of_string :
  string -> order
  (** Deserialize JSON data of type {!order}. *)

val write_sort_order :
  Bi_outbuf.t -> sort_order -> unit
  (** Output a JSON value of type {!sort_order}. *)

val string_of_sort_order :
  ?len:int -> sort_order -> string
  (** Serialize a value of type {!sort_order}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_sort_order :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> sort_order
  (** Input JSON data of type {!sort_order}. *)

val sort_order_of_string :
  string -> sort_order
  (** Deserialize JSON data of type {!sort_order}. *)

val write_query_request :
  Bi_outbuf.t -> query_request -> unit
  (** Output a JSON value of type {!query_request}. *)

val string_of_query_request :
  ?len:int -> query_request -> string
  (** Serialize a value of type {!query_request}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_query_request :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> query_request
  (** Input JSON data of type {!query_request}. *)

val query_request_of_string :
  string -> query_request
  (** Deserialize JSON data of type {!query_request}. *)

val write_hits :
  (Bi_outbuf.t -> 'hit -> unit) ->
  Bi_outbuf.t -> 'hit hits -> unit
  (** Output a JSON value of type {!hits}. *)

val string_of_hits :
  (Bi_outbuf.t -> 'hit -> unit) ->
  ?len:int -> 'hit hits -> string
  (** Serialize a value of type {!hits}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_hits :
  (Yojson.Safe.lexer_state -> Lexing.lexbuf -> 'hit) ->
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> 'hit hits
  (** Input JSON data of type {!hits}. *)

val hits_of_string :
  (Yojson.Safe.lexer_state -> Lexing.lexbuf -> 'hit) ->
  string -> 'hit hits
  (** Deserialize JSON data of type {!hits}. *)

val write_shards :
  Bi_outbuf.t -> shards -> unit
  (** Output a JSON value of type {!shards}. *)

val string_of_shards :
  ?len:int -> shards -> string
  (** Serialize a value of type {!shards}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_shards :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> shards
  (** Input JSON data of type {!shards}. *)

val shards_of_string :
  string -> shards
  (** Deserialize JSON data of type {!shards}. *)

val write_search_result :
  (Bi_outbuf.t -> 'hit -> unit) ->
  Bi_outbuf.t -> 'hit search_result -> unit
  (** Output a JSON value of type {!search_result}. *)

val string_of_search_result :
  (Bi_outbuf.t -> 'hit -> unit) ->
  ?len:int -> 'hit search_result -> string
  (** Serialize a value of type {!search_result}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_search_result :
  (Yojson.Safe.lexer_state -> Lexing.lexbuf -> 'hit) ->
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> 'hit search_result
  (** Input JSON data of type {!search_result}. *)

val search_result_of_string :
  (Yojson.Safe.lexer_state -> Lexing.lexbuf -> 'hit) ->
  string -> 'hit search_result
  (** Deserialize JSON data of type {!search_result}. *)

val write_get_result :
  (Bi_outbuf.t -> 'item -> unit) ->
  Bi_outbuf.t -> 'item get_result -> unit
  (** Output a JSON value of type {!get_result}. *)

val string_of_get_result :
  (Bi_outbuf.t -> 'item -> unit) ->
  ?len:int -> 'item get_result -> string
  (** Serialize a value of type {!get_result}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_get_result :
  (Yojson.Safe.lexer_state -> Lexing.lexbuf -> 'item) ->
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> 'item get_result
  (** Input JSON data of type {!get_result}. *)

val get_result_of_string :
  (Yojson.Safe.lexer_state -> Lexing.lexbuf -> 'item) ->
  string -> 'item get_result
  (** Deserialize JSON data of type {!get_result}. *)

val write_get_request_key :
  Bi_outbuf.t -> get_request_key -> unit
  (** Output a JSON value of type {!get_request_key}. *)

val string_of_get_request_key :
  ?len:int -> get_request_key -> string
  (** Serialize a value of type {!get_request_key}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_get_request_key :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> get_request_key
  (** Input JSON data of type {!get_request_key}. *)

val get_request_key_of_string :
  string -> get_request_key
  (** Deserialize JSON data of type {!get_request_key}. *)

val write_get_request :
  Bi_outbuf.t -> get_request -> unit
  (** Output a JSON value of type {!get_request}. *)

val string_of_get_request :
  ?len:int -> get_request -> string
  (** Serialize a value of type {!get_request}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_get_request :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> get_request
  (** Input JSON data of type {!get_request}. *)

val get_request_of_string :
  string -> get_request
  (** Deserialize JSON data of type {!get_request}. *)

val write_get_results :
  (Bi_outbuf.t -> 'item -> unit) ->
  Bi_outbuf.t -> 'item get_results -> unit
  (** Output a JSON value of type {!get_results}. *)

val string_of_get_results :
  (Bi_outbuf.t -> 'item -> unit) ->
  ?len:int -> 'item get_results -> string
  (** Serialize a value of type {!get_results}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_get_results :
  (Yojson.Safe.lexer_state -> Lexing.lexbuf -> 'item) ->
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> 'item get_results
  (** Input JSON data of type {!get_results}. *)

val get_results_of_string :
  (Yojson.Safe.lexer_state -> Lexing.lexbuf -> 'item) ->
  string -> 'item get_results
  (** Deserialize JSON data of type {!get_results}. *)

val write_delete_result :
  Bi_outbuf.t -> delete_result -> unit
  (** Output a JSON value of type {!delete_result}. *)

val string_of_delete_result :
  ?len:int -> delete_result -> string
  (** Serialize a value of type {!delete_result}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_delete_result :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> delete_result
  (** Input JSON data of type {!delete_result}. *)

val delete_result_of_string :
  string -> delete_result
  (** Deserialize JSON data of type {!delete_result}. *)

val write_index_result :
  Bi_outbuf.t -> index_result -> unit
  (** Output a JSON value of type {!index_result}. *)

val string_of_index_result :
  ?len:int -> index_result -> string
  (** Serialize a value of type {!index_result}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_index_result :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> index_result
  (** Input JSON data of type {!index_result}. *)

val index_result_of_string :
  string -> index_result
  (** Deserialize JSON data of type {!index_result}. *)

val write_update_request :
  (Bi_outbuf.t -> 'item -> unit) ->
  Bi_outbuf.t -> 'item update_request -> unit
  (** Output a JSON value of type {!update_request}. *)

val string_of_update_request :
  (Bi_outbuf.t -> 'item -> unit) ->
  ?len:int -> 'item update_request -> string
  (** Serialize a value of type {!update_request}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_update_request :
  (Yojson.Safe.lexer_state -> Lexing.lexbuf -> 'item) ->
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> 'item update_request
  (** Input JSON data of type {!update_request}. *)

val update_request_of_string :
  (Yojson.Safe.lexer_state -> Lexing.lexbuf -> 'item) ->
  string -> 'item update_request
  (** Deserialize JSON data of type {!update_request}. *)

val write_update_result :
  Bi_outbuf.t -> update_result -> unit
  (** Output a JSON value of type {!update_result}. *)

val string_of_update_result :
  ?len:int -> update_result -> string
  (** Serialize a value of type {!update_result}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_update_result :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> update_result
  (** Input JSON data of type {!update_result}. *)

val update_result_of_string :
  string -> update_result
  (** Deserialize JSON data of type {!update_result}. *)

val write_hit :
  (Bi_outbuf.t -> 'item -> unit) ->
  Bi_outbuf.t -> 'item hit -> unit
  (** Output a JSON value of type {!hit}. *)

val string_of_hit :
  (Bi_outbuf.t -> 'item -> unit) ->
  ?len:int -> 'item hit -> string
  (** Serialize a value of type {!hit}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_hit :
  (Yojson.Safe.lexer_state -> Lexing.lexbuf -> 'item) ->
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> 'item hit
  (** Input JSON data of type {!hit}. *)

val hit_of_string :
  (Yojson.Safe.lexer_state -> Lexing.lexbuf -> 'item) ->
  string -> 'item hit
  (** Deserialize JSON data of type {!hit}. *)

