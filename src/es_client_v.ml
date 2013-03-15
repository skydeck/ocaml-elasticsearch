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

let validate_json = (
  Es_untyped_json.validate_json
)
let validate__1 = (
  fun _ _ -> None
)
let validate__2 = (
  fun _ _ -> None
)
let validate_simplified_result = (
  fun _ _ -> None
)
let validate_index_settings = (
  fun _ _ -> None
)
let validate__3 = (
  fun _ _ -> None
)
let validate__4 = (
  Ag_ov_run.validate_list (
    fun path x ->
      (let _, x = x in
      (
        validate_json
      ) (`Index 1 :: path) x
      )
  )
)
let validate_create_index_request = (
  fun path x ->
    (
      validate__4
    ) (`Field "mappings" :: path) x.mappings
)
let validate_order = (
  fun _ _ -> None
)
let validate__5 = (
  fun _ _ -> None
)
let validate_sort_order = (
  fun _ _ -> None
)
let validate__6 = (
  fun _ _ -> None
)
let validate__7 = (
  fun _ _ -> None
)
let validate__8 = (
  fun _ _ -> None
)
let validate_query_request = (
  fun path x ->
    (
      validate_json
    ) (`Field "query" :: path) x.query
)
let validate__15 = (
  fun _ _ -> None
)
let validate__16 validate__a = (
  Ag_ov_run.validate_list (
    validate__a
  )
)
let validate_hits validate__hit = (
  fun path x ->
    (
      validate__16 validate__hit
    ) (`Field "hts_hits" :: path) x.hts_hits
)
let validate__10 validate__a = (
  Ag_ov_run.validate_option (
    validate_hits validate__a
  )
)
let validate_shards = (
  fun _ _ -> None
)
let validate__9 = (
  fun _ _ -> None
)
let validate_search_result validate__hit = (
  fun path x ->
    (
      validate__10 validate__hit
    ) (`Field "sr_hits" :: path) x.sr_hits
)
let validate__11 validate__a = (
  Ag_ov_run.validate_option (
    validate__a
  )
)
let validate_get_result validate__item = (
  fun path x ->
    (
      validate__11 validate__item
    ) (`Field "gr_item" :: path) x.gr_item
)
let validate_get_request_key = (
  fun _ _ -> None
)
let validate__12 = (
  fun _ _ -> None
)
let validate_get_request = (
  fun _ _ -> None
)
let validate__13 validate__a = (
  Ag_ov_run.validate_list (
    validate_get_result validate__a
  )
)
let validate__14 validate__a = (
  Ag_ov_run.validate_option (
    validate__13 validate__a
  )
)
let validate_get_results validate__item = (
  fun path x ->
    (
      validate__14 validate__item
    ) (`Field "grs_docs" :: path) x.grs_docs
)
let validate_delete_result = (
  fun _ _ -> None
)
let validate_index_result = (
  fun _ _ -> None
)
let validate_update_request validate__item = (
  fun path x ->
    (
      validate__item
    ) (`Field "ur_doc" :: path) x.ur_doc
)
let validate_update_result = (
  fun _ _ -> None
)
let validate_hit validate__item = (
  fun path x ->
    (
      validate__item
    ) (`Field "ht_item" :: path) x.ht_item
)
let create_simplified_result 
  ?error
  ?status
  () =
  {
    error = error;
    status = status;
  }
let create_index_settings 
  ?number_of_shards
  ?number_of_replicas
  () =
  {
    number_of_shards = number_of_shards;
    number_of_replicas = number_of_replicas;
  }
let create_create_index_request 
  ?settings
  ?(mappings = [])
  () =
  {
    settings = settings;
    mappings = mappings;
  }
let create_sort_order 
  ~order
  ?ignore_unmapped
  () =
  {
    order = order;
    ignore_unmapped = ignore_unmapped;
  }
let create_query_request 
  ~query
  ?(from = 0)
  ~size
  ?sort
  ~track_scores
  () =
  {
    query = query;
    from = from;
    size = size;
    sort = sort;
    track_scores = track_scores;
  }
let create_hits 
  ~hts_total
  ?hts_max_score
  ?(hts_hits = [])
  () =
  {
    hts_total = hts_total;
    hts_max_score = hts_max_score;
    hts_hits = hts_hits;
  }
let create_shards 
  ~sd_total
  ~sd_successful
  ~sd_failed
  () =
  {
    sd_total = sd_total;
    sd_successful = sd_successful;
    sd_failed = sd_failed;
  }
let create_search_result 
  ?sr_took
  ?sr_timed_out
  ?sr_shards
  ?sr_hits
  ?sr_error
  ?sr_status
  ?sr_count
  () =
  {
    sr_took = sr_took;
    sr_timed_out = sr_timed_out;
    sr_shards = sr_shards;
    sr_hits = sr_hits;
    sr_error = sr_error;
    sr_status = sr_status;
    sr_count = sr_count;
  }
let create_get_result 
  ?gr_id
  ?gr_index
  ?gr_type
  ?gr_version
  ?gr_exists
  ?gr_item
  ?gr_error
  ?gr_status
  () =
  {
    gr_id = gr_id;
    gr_index = gr_index;
    gr_type = gr_type;
    gr_version = gr_version;
    gr_exists = gr_exists;
    gr_item = gr_item;
    gr_error = gr_error;
    gr_status = gr_status;
  }
let create_get_request_key 
  ~grq_id
  ?grq_routing
  () =
  {
    grq_id = grq_id;
    grq_routing = grq_routing;
  }
let create_get_request 
  ~grq_docs
  () =
  {
    grq_docs = grq_docs;
  }
let create_get_results 
  ?grs_docs
  ?grs_error
  ?grs_status
  () =
  {
    grs_docs = grs_docs;
    grs_error = grs_error;
    grs_status = grs_status;
  }
let create_delete_result 
  ?dr_id
  ?dr_index
  ?dr_type
  ?dr_version
  ?dr_found
  ?dr_ok
  ?dr_error
  ?dr_status
  () =
  {
    dr_id = dr_id;
    dr_index = dr_index;
    dr_type = dr_type;
    dr_version = dr_version;
    dr_found = dr_found;
    dr_ok = dr_ok;
    dr_error = dr_error;
    dr_status = dr_status;
  }
let create_index_result 
  ?ir_id
  ?ir_index
  ?ir_type
  ?ir_version
  ?ir_ok
  ?ir_error
  ?ir_status
  () =
  {
    ir_id = ir_id;
    ir_index = ir_index;
    ir_type = ir_type;
    ir_version = ir_version;
    ir_ok = ir_ok;
    ir_error = ir_error;
    ir_status = ir_status;
  }
let create_update_request 
  ~ur_doc
  () =
  {
    ur_doc = ur_doc;
  }
let create_update_result 
  ?ur_id
  ?ur_index
  ?ur_type
  ?ur_version
  ?ur_ok
  ?ur_error
  ?ur_status
  () =
  {
    ur_id = ur_id;
    ur_index = ur_index;
    ur_type = ur_type;
    ur_version = ur_version;
    ur_ok = ur_ok;
    ur_error = ur_error;
    ur_status = ur_status;
  }
let create_hit 
  ~ht_id
  ~ht_index
  ~ht_type
  ~ht_score
  ~ht_item
  () =
  {
    ht_id = ht_id;
    ht_index = ht_index;
    ht_type = ht_type;
    ht_score = ht_score;
    ht_item = ht_item;
  }
