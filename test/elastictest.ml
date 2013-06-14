(*
  Create a fresh index with a random name,
  define a mapping,
  index some documents,
  check that the everything is searchable as intended,
  delete the index.

  This test is about correctness, not performance.
*)

open Printf
open Es_client_t
open Es_query
open Test_mapping_t

module ES = Es_client.Make
  (Test_util.Lwt_http_client)
  (Es_client.Default_address)
  (struct
    open Test_mapping_j
    type t = doc
    let read ~doc_type ls lb = read_doc ls lb
    let write = write_doc
  end)

let sync = Lwt_main.run

let error s =
  eprintf "[ERROR] %s\n%!" s;
  failwith "Unfinished"

let create_index name mapping =
  sync (ES.create_index name [mapping])

let get_document_mapping index_name mapping_name =
  sync (ES.get_mapping index_name mapping_name)
  (* HTTP response already displayed *)

let validate_doc doc =
  match Test_mapping_v.validate_doc [] doc with
      None -> ()
    | Some err ->
        error (sprintf "Invalid doc:\n%s\n%s"
                 (Ag_util.Validation.string_of_error err)
                 (Yojson.Basic.prettify (Test_mapping_j.string_of_doc doc)))

let index_item index_name mapping_name doc =
  sync (ES.index_item
          ~index: index_name
          ~mapping: mapping_name
          ~id: doc.Test_mapping_t.id
          ~item: doc
          ())

let index_items index_name mapping_name l =
  List.iter (index_item index_name mapping_name) l

let test_item_exists index_name mapping_name x =
  let y = sync (ES.get_item index_name mapping_name x.id) in
  if y <> Some x then (
    printf "\
Document %s not identical to original.
(two docs using the same ID?)\n%!"
      x.id;
    exit 1
  )

let test_item_doesnt_exist index_name mapping_name x =
  match sync (ES.get_item index_name mapping_name x.id) with
      None -> ()
    | Some _ ->
        printf "Document %s is still there.\n%!" x.id;
        exit 1

let test_items_exist index_name mapping_name l =
  List.iter (test_item_exists index_name mapping_name) l

let test_items_dont_exist index_name mapping_name l =
  List.iter (test_item_doesnt_exist index_name mapping_name) l

let delete_item index_name mapping_name x =
  ignore (sync (ES.delete_item
                  ~index: index_name
                  ~mapping: mapping_name
                  ~id:x.id))

let delete_items index_name mapping_name l =
  List.iter (delete_item index_name mapping_name) l

let search_missing_indexes mapping_name =
  try
    let _results =
      sync (ES.search
              ~indexes: [ "not_an_index1"; "missing_index2" ]
              ~mappings: [ mapping_name ]
              Match_all)
    in
    printf "Incorrect response for a query to missing indexes.\n%!";
    exit 1
  with Es_error.Error _ ->
    printf "Good, we got an error because the indexes are missing.\n%!"

let test_query index_name mapping_name (query_name, query, expected_hits) =
  printf "\n---------- %s ----------\n\n%!" query_name;
  let results =
    sync (ES.search
            ~indexes: [index_name]
            ~mappings: [mapping_name]
            query)
  in
  match results.sr_hits with
      Some x -> (query_name, expected_hits, x.hts_total)
    | None -> failwith "no result"

let test_queries index_name mapping_name l =
  let results = List.map (test_query index_name mapping_name) l in
  let errors = ref 0 in
  List.iter (
    fun (name, expected, actual) ->
      let status =
        if expected = actual then "[OK]"
        else (
          incr errors;
          "[ERROR]"
        )
      in
      printf "%-7s %s %i/%i\n" status name actual expected
  ) results;
  printf "Errors: %i/%i\n" !errors (List.length results);
  flush stdout;
  if !errors = 0 then (
    print_endline "Awesome!";
    true
  )
  else
    false

let delete_index index_name =
  sync (ES.delete_index index_name)

let mapping = Es_mapping.({
  doc_type = "doc";
  doc_parent = None;
  doc_all_field = false;
  doc_indexed_fields = [
    field "id" Token;
    field "username" Token;
    field "name" Text;
    field "gender" Byte;
    field "location" Geo_point;
    field "locations" (
      Array (
        Object [
          field "coord" Geo_point;
          field "loc_name" Text;
        ]
      )
    );
    field "dob" Date;
  ];
})

let location name lat lon =
  {
    loc_name = name;
    coord = { Es_field_types_t.lat; lon}
  }

let san_francisco = location "San Francisco" 37.7793 (-122.4192)
let palo_alto = location "Palo Alto, California" 37.429167 (-122.138056)
let mountain_view = location "Mountain View" 37.389444 (-122.081944)

let female = 0
let male = 1
let other_gender = 2

let docs =
  let open Test_mapping_t in [
    Test_mapping_v.create_doc
      ~lucky_numbers: [ 1; 1; 2; 3; 5; 8; 13; 21 ]
      ~id: "PQeKRgNkHdXJgVhRBtWirg"
      ~username: "SpongebobSquarepants2012"
      ~name: "Jimmy Pesto"
      ~gender: male
      ~location: san_francisco.coord
      ~locations: [ san_francisco ]
      ~dob: "1969-08-15"
      ~blob: "KABAf4D/KQ=="
             (*(Nlencoding.Base64.encode "(\000\064\127\128\255)")*)
      ();
    Test_mapping_v.create_doc
      ~lucky_numbers: [ 456 ]
      ~id: "PQkzYQ_yztTD9kRVbmo2iQ"
      ~username: "Number 2" (* should be indexed as one token *)
      ~name: "Number Two"
      ~gender: male
      ~location: palo_alto.coord
      ~locations: [ palo_alto ]
      ~dob: "1979-05-17"
      ~blob: "KABAf4D/KQ=="
             (*(Nlencoding.Base64.encode "(\000\064\127\128\255)")*)
      ();

    Test_mapping_v.create_doc
      ~id: "PQpOuer2M2gIspKgfCQYMg"
      ~username: "jdoe"
      ~name: "Jane Doe"
      ~gender: female
      ~location: mountain_view.coord
      ~dob: "1976-11-03"
      ();

    Test_mapping_v.create_doc
      ~id: "PQ2BEyWENZ_Ig0FT6ozxgA"
      ~username: "jjdoe"
      ~name: "John Doe"
      ~gender: male
      ~location: palo_alto.coord
      ~locations: [ palo_alto; san_francisco ]
      ~dob: "1990-01-15"
      ();
  ]

let match_all2 =
  Bool (create_bool_query ~must: [Match_all] ())

let q1 =
  Match_and ("name", "jimmy")

let q_dob =
  Filter (Match_and ("name", "jimmy"),
          Query (Date_range ("dob", "1960-01-01", "1969-12-31", None)))

let q_mv20 =
  Filter (Match_all,
          Geo_distance_filter ("location", mountain_view.coord, 20.))

let q_mv20_multiloc =
  Filter (Match_all,
          Geo_distance_filter
            ("locations.coord", mountain_view.coord, 20.))

let q_sf_multiloc =
  Filter (Match_all,
          Geo_distance_filter
            ("locations.coord", san_francisco.coord, 20.))

let q_username =
  Match_and ("username", "Number 2")

let q_username_no_match =
  Match_and ("foo.username", "Number")

let q_gender =
  Filter (
    Match_all,
    Numeric_range_filter ("gender", Some female, Some female)
  )

let q_superfilter =
  Filter (
    Match_all,
    And_filter [
      Geo_distance_filter ("location", mountain_view.coord, 20.);
      Query (Date_range ("dob", "1970-01-01", "1980-12-31", None));
      Numeric_range_filter ("gender", Some female, Some female);
    ]
  )

let queries =
  let all = List.length docs in
  [
    (* test name, query, expected hit count *)
    "match_all", Match_all, all;
    "match_all2", match_all2, all;
    "q1", q1, 1;
    "q_dob", q_dob, 1;
    "q_mv20", q_mv20, 3;
    "q_mv20_multiloc", q_mv20_multiloc, 2;
    "q_sf_multiloc", q_sf_multiloc, 2;
    "q_username", q_username, 1;
    "q_username_no_match", q_username_no_match, 0;
    "q_gender", q_gender, 1;
    "q_superfilter", q_superfilter, 1;
  ]

let sleep t =
  printf "Sleeping %g seconds\n%!" t;
  ignore (Unix.select [] [] [] t)

let run_tests ~keep =
  let lag = 2. in

  Random.self_init ();
  let index_name = "test" ^ string_of_int (Random.bits ()) in
  let mapping_name = mapping.Es_mapping.doc_type in

  printf "Creating temporary index %s\n%!" index_name;
  create_index index_name mapping;
  sleep lag;
  printf "Fetching document mapping (informational)\n%!";
  print_endline (get_document_mapping index_name mapping_name);

  let fin () =
    if not keep then (
      printf "Deleting index %s (use -keep to disable)\n%!" index_name;
      delete_index index_name;
    )
  in
  try
    printf "Validating documents\n%!";
    List.iter validate_doc docs;
    printf "Indexing documents\n%!";
    index_items index_name mapping_name docs;
    sleep lag;

    printf "Testing get_item\n%!";
    test_items_exist index_name mapping_name docs;
    printf "Deleting all items\n%!";
    delete_items index_name mapping_name docs;
    sleep lag;

    printf "Testing that all items are gone\n%!";
    test_items_dont_exist index_name mapping_name docs;
    printf "Indexing documents (after deletion)\n%!";
    index_items index_name mapping_name docs;
    sleep lag;

    printf "Searching in missing indexes%!\n";
    search_missing_indexes mapping_name;

    printf "Testing search\n%!";
    let passed = test_queries index_name mapping_name queries in
    printf "Done.\n%!";
    fin ();
    exit (if passed then 0 else 1)
  with e ->
    fin ();
    raise e

let main () =
  let keep = ref false in
  let options = [
    "-keep", Arg.Set keep, "do not remove the temporary index when done"
  ]
  in
  let anon_fun s = failwith ("unsupported argument " ^ s) in
  let usage_msg = sprintf "Usage: %s [options]" Sys.argv.(0) in
  Arg.parse options anon_fun usage_msg;
  run_tests ~keep: !keep

let () = main ()
