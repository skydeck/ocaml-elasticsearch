(* Auto-generated from "es_client.atd" *)


type json = Es_untyped_json.json

type simplified_result = { error: string option; status: int option }

type index_settings = {
  number_of_shards: int option;
  number_of_replicas: int option
}

type create_index_request = {
  settings: index_settings option;
  mappings: (string * json) list
}

type order = [ `Asc | `Desc ]

type sort_order = { order: order; ignore_unmapped: bool option }

type query_request = {
  query: json;
  from: int;
  size: int;
  sort: (string * sort_order) list list option;
  track_scores: bool
}

type 'hit hits = {
  hts_total (*atd total *): int;
  hts_max_score (*atd max_score *): float option;
  hts_hits (*atd hits *): 'hit list
}

type shards = {
  sd_total (*atd total *): int;
  sd_successful (*atd successful *): int;
  sd_failed (*atd failed *): int
}

type 'hit search_result = {
  sr_took (*atd took *): int option;
  sr_timed_out (*atd timed_out *): bool option;
  sr_shards: shards option;
  sr_hits (*atd hits *): 'hit hits option;
  sr_error (*atd error *): string option;
  sr_status (*atd status *): int option;
  sr_count (*atd count *): int option
}

type 'item get_result = {
  gr_id: string option;
  gr_index: string option;
  gr_type: string option;
  gr_version: int option;
  gr_exists (*atd exists *): bool option;
  gr_item: 'item option;
  gr_error (*atd error *): string option;
  gr_status (*atd status *): int option
}

type get_request_key = {
  grq_id (*atd id *): string;
  grq_routing (*atd routing *): string option
}

type get_request = { grq_docs (*atd docs *): get_request_key list }

type 'item get_results = {
  grs_docs (*atd docs *): 'item get_result list option;
  grs_error (*atd error *): string option;
  grs_status (*atd status *): int option
}

type delete_result = {
  dr_id: string option;
  dr_index: string option;
  dr_type: string option;
  dr_version: int option;
  dr_found (*atd found *): bool option;
  dr_ok (*atd ok *): bool option;
  dr_error (*atd error *): string option;
  dr_status (*atd status *): int option
}

type index_result = {
  ir_id: string option;
  ir_index: string option;
  ir_type: string option;
  ir_version: int option;
  ir_ok (*atd ok *): bool option;
  ir_error (*atd error *): string option;
  ir_status (*atd status *): int option
}

type 'item update_request = { ur_doc (*atd doc *): 'item }

type update_result = {
  ur_id: string option;
  ur_index: string option;
  ur_type: string option;
  ur_version: int option;
  ur_ok (*atd ok *): bool option;
  ur_error (*atd error *): string option;
  ur_status (*atd status *): int option
}

type 'item hit = {
  ht_id: string;
  ht_index: string;
  ht_type: string;
  ht_score: float;
  ht_item: 'item
}
