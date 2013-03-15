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
  sr_status (*atd status *): int option;
  sr_count (*atd count *): int option
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

val validate_json :
  Ag_util.Validation.path -> json -> Ag_util.Validation.error option
  (** Validate a value of type {!json}. *)

val create_simplified_result :
  ?error: string ->
  ?status: int ->
  unit -> simplified_result
  (** Create a record of type {!simplified_result}. *)

val validate_simplified_result :
  Ag_util.Validation.path -> simplified_result -> Ag_util.Validation.error option
  (** Validate a value of type {!simplified_result}. *)

val create_index_settings :
  ?number_of_shards: int ->
  ?number_of_replicas: int ->
  unit -> index_settings
  (** Create a record of type {!index_settings}. *)

val validate_index_settings :
  Ag_util.Validation.path -> index_settings -> Ag_util.Validation.error option
  (** Validate a value of type {!index_settings}. *)

val create_create_index_request :
  ?settings: index_settings ->
  ?mappings: (string * json) list ->
  unit -> create_index_request
  (** Create a record of type {!create_index_request}. *)

val validate_create_index_request :
  Ag_util.Validation.path -> create_index_request -> Ag_util.Validation.error option
  (** Validate a value of type {!create_index_request}. *)

val validate_order :
  Ag_util.Validation.path -> order -> Ag_util.Validation.error option
  (** Validate a value of type {!order}. *)

val create_sort_order :
  order: order ->
  ?ignore_unmapped: bool ->
  unit -> sort_order
  (** Create a record of type {!sort_order}. *)

val validate_sort_order :
  Ag_util.Validation.path -> sort_order -> Ag_util.Validation.error option
  (** Validate a value of type {!sort_order}. *)

val create_query_request :
  query: json ->
  ?from: int ->
  size: int ->
  ?sort: (string * sort_order) list list ->
  track_scores: bool ->
  unit -> query_request
  (** Create a record of type {!query_request}. *)

val validate_query_request :
  Ag_util.Validation.path -> query_request -> Ag_util.Validation.error option
  (** Validate a value of type {!query_request}. *)

val create_hits :
  hts_total: int ->
  ?hts_max_score: float ->
  ?hts_hits: 'hit list ->
  unit -> 'hit hits
  (** Create a record of type {!hits}. *)

val validate_hits :
  (Ag_util.Validation.path -> 'hit -> Ag_util.Validation.error option) ->
  Ag_util.Validation.path -> 'hit hits -> Ag_util.Validation.error option
  (** Validate a value of type {!hits}. *)

val create_shards :
  sd_total: int ->
  sd_successful: int ->
  sd_failed: int ->
  unit -> shards
  (** Create a record of type {!shards}. *)

val validate_shards :
  Ag_util.Validation.path -> shards -> Ag_util.Validation.error option
  (** Validate a value of type {!shards}. *)

val create_search_result :
  ?sr_took: int ->
  ?sr_timed_out: bool ->
  ?sr_shards: shards ->
  ?sr_hits: 'hit hits ->
  ?sr_error: string ->
  ?sr_status: int ->
  ?sr_count: int ->
  unit -> 'hit search_result
  (** Create a record of type {!search_result}. *)

val validate_search_result :
  (Ag_util.Validation.path -> 'hit -> Ag_util.Validation.error option) ->
  Ag_util.Validation.path -> 'hit search_result -> Ag_util.Validation.error option
  (** Validate a value of type {!search_result}. *)

val create_get_result :
  ?gr_id: string ->
  ?gr_index: string ->
  ?gr_type: string ->
  ?gr_version: int ->
  ?gr_exists: bool ->
  ?gr_item: 'item ->
  ?gr_error: string ->
  ?gr_status: int ->
  unit -> 'item get_result
  (** Create a record of type {!get_result}. *)

val validate_get_result :
  (Ag_util.Validation.path -> 'item -> Ag_util.Validation.error option) ->
  Ag_util.Validation.path -> 'item get_result -> Ag_util.Validation.error option
  (** Validate a value of type {!get_result}. *)

val create_get_request_key :
  grq_id: string ->
  ?grq_routing: string ->
  unit -> get_request_key
  (** Create a record of type {!get_request_key}. *)

val validate_get_request_key :
  Ag_util.Validation.path -> get_request_key -> Ag_util.Validation.error option
  (** Validate a value of type {!get_request_key}. *)

val create_get_request :
  grq_docs: get_request_key list ->
  unit -> get_request
  (** Create a record of type {!get_request}. *)

val validate_get_request :
  Ag_util.Validation.path -> get_request -> Ag_util.Validation.error option
  (** Validate a value of type {!get_request}. *)

val create_get_results :
  ?grs_docs: 'item get_result list ->
  ?grs_error: string ->
  ?grs_status: int ->
  unit -> 'item get_results
  (** Create a record of type {!get_results}. *)

val validate_get_results :
  (Ag_util.Validation.path -> 'item -> Ag_util.Validation.error option) ->
  Ag_util.Validation.path -> 'item get_results -> Ag_util.Validation.error option
  (** Validate a value of type {!get_results}. *)

val create_delete_result :
  ?dr_id: string ->
  ?dr_index: string ->
  ?dr_type: string ->
  ?dr_version: int ->
  ?dr_found: bool ->
  ?dr_ok: bool ->
  ?dr_error: string ->
  ?dr_status: int ->
  unit -> delete_result
  (** Create a record of type {!delete_result}. *)

val validate_delete_result :
  Ag_util.Validation.path -> delete_result -> Ag_util.Validation.error option
  (** Validate a value of type {!delete_result}. *)

val create_index_result :
  ?ir_id: string ->
  ?ir_index: string ->
  ?ir_type: string ->
  ?ir_version: int ->
  ?ir_ok: bool ->
  ?ir_error: string ->
  ?ir_status: int ->
  unit -> index_result
  (** Create a record of type {!index_result}. *)

val validate_index_result :
  Ag_util.Validation.path -> index_result -> Ag_util.Validation.error option
  (** Validate a value of type {!index_result}. *)

val create_update_request :
  ur_doc: 'item ->
  unit -> 'item update_request
  (** Create a record of type {!update_request}. *)

val validate_update_request :
  (Ag_util.Validation.path -> 'item -> Ag_util.Validation.error option) ->
  Ag_util.Validation.path -> 'item update_request -> Ag_util.Validation.error option
  (** Validate a value of type {!update_request}. *)

val create_update_result :
  ?ur_id: string ->
  ?ur_index: string ->
  ?ur_type: string ->
  ?ur_version: int ->
  ?ur_ok: bool ->
  ?ur_error: string ->
  ?ur_status: int ->
  unit -> update_result
  (** Create a record of type {!update_result}. *)

val validate_update_result :
  Ag_util.Validation.path -> update_result -> Ag_util.Validation.error option
  (** Validate a value of type {!update_result}. *)

val create_hit :
  ht_id: string ->
  ht_index: string ->
  ht_type: string ->
  ht_score: float ->
  ht_item: 'item ->
  unit -> 'item hit
  (** Create a record of type {!hit}. *)

val validate_hit :
  (Ag_util.Validation.path -> 'item -> Ag_util.Validation.error option) ->
  Ag_util.Validation.path -> 'item hit -> Ag_util.Validation.error option
  (** Validate a value of type {!hit}. *)

