(**
   Please read the documentation at
   http://www.elasticsearch.org/guide/reference/query-dsl/
*)

open Printf

type field_name = string
type field_value = string

type date = string

type boost = float

type coord = Es_field_types_t.coord = {
  lat : float;
  lon : float;
}

type radius_km = float

type parent_type = string
    (* elasticsearch type of the document registered as _parent
       (see 'has_parent' section of the documentation) *)

type with_score = bool

(**
   Unlike queries, filters do not contribute any score.
*)

type query =
  | Match_all
  | Term_query of field_name * field_value
  | Match_and of field_name * field_value (* parse and match all terms *)
  | Match_or of field_name * field_value (* parse and match at least one term *)
  | Match_phrase of field_name * field_value
  | Match_phrase_prefix of field_name * field_value * int option
  | Boolean of field_name * bool
  | Date_range of field_name * date * date * boost option
  | Date_from of field_name * date * boost option
  | Date_to of field_name * date * boost option
  | Bool of bool_query
  | Boost of float * query
  | Constant_score_query of float * query
  | Constant_score_filter of float option * filter
  | Filter of query * filter (* query AND filter *)
  | Parent of parent_type * with_score * query (* query the parent document *)

and filter =
  | Term_filter of field_name * string
  | Geo_distance_filter of field_name * coord * radius_km
  | Numeric_range_filter of field_name * int option * int option
  | And_filter of filter list
  | Or_filter of filter list
  | Not_filter of filter
  | Exists_filter of field_name
  | Missing_filter of field_name
  | Document_type of string
  | Query of query (* not sure about this one; seems to work for date ranges *)

and bool_query = {
  (** At least one "must" or one "should" query should be specified *)
  must : query list;
  should : query list;
  must_not : query list;
  minimum_number_should_match : int;
    (* default: 1 *)
  disable_coord : bool;
    (* disable scoring based on the fraction of all query terms
       that a document contains (default: false) *)
}

let with_boost ~cst_score boost fields =
  match boost with
    | Some boost when not cst_score -> ("boost", `Float boost) :: fields
    | _ -> fields

let create_bool_query
    ?(must = [])
    ?(should = [])
    ?(must_not = [])
    ?(minimum_number_should_match = 1)
    ?(disable_coord = false)
    () =
  { must; should; must_not; minimum_number_should_match; disable_coord }

let rec to_json_ast ~cst_score = function
  | Match_all -> `Assoc [ "match_all", `Assoc [] ]

  | Term_query (name, s) ->
      `Assoc [
        "term", `Assoc [
          name, `String s
        ]
      ]

  | Match_and (name, value) ->
      `Assoc [
        "match", `Assoc [
          name, `Assoc [ "query", `String value;
                         "operator", `String "and" ]
        ]
      ]

  | Match_or (name, value) ->
      `Assoc [
        "match", `Assoc [
          name, `Assoc [ "query", `String value;
                         "operator", `String "or" ]
        ]
      ]

  | Match_phrase (name, value) ->
      `Assoc [
        "match_phrase", `Assoc [
          name, `String value
        ]
      ]

  | Match_phrase_prefix (name, value, opt_max_expansions) ->
      let max_expansions =
        match opt_max_expansions with
            None -> 10
          | Some n -> n
      in
      `Assoc [
        "match", `Assoc [
          name, `Assoc [
            "query", `String value;
            "type", `String "phrase_prefix";
            "max_expansions", `Int max_expansions;
          ]
        ]
      ]

  | Boolean (name, b) ->
      `Assoc [
        "match", `Assoc [
          name, `Bool b
        ]
      ]

  | Bool x ->
      let must =
        match x.must with
            [] -> []
          | l -> [ "must", `List (List.map (to_json_ast ~cst_score) l) ]
      in
      let should =
        match x.should with
            [] -> []
          | l -> [ "should", `List (List.map (to_json_ast ~cst_score) l) ]
      in
      if must = [] && should = [] then
        invalid_arg
          "Es_query.to_json_ast: \
           Bool query needs at least one 'must' or one 'should' clause.";
      let must_not =
        match x.must_not with
            [] -> []
          | l ->
              [ "must_not", `List (List.map (to_json_ast ~cst_score:true) l) ]
      in
      let mini =
        [ "minimum_number_should_match", `Int x.minimum_number_should_match ]
      in
      `Assoc [ "bool", `Assoc (must @ should @ must_not @ mini) ]

  | Boost (x, q) ->
      if cst_score then
        to_json_ast ~cst_score q
      else
        `Assoc [
          "custom_boost_factor", `Assoc [
            "boost_factor", `Float x;
            "query", to_json_ast ~cst_score q;
          ]
        ]

  | Constant_score_query (boost, q) ->
      if cst_score then
        to_json_ast ~cst_score:true q
      else
        `Assoc [
          "constant_score", `Assoc [
            "boost", `Float boost;
            "query", to_json_ast ~cst_score:true q;
          ]
        ]

  | Constant_score_filter (optboost, q) ->
      let b =
        match optboost with
            None -> []
          | Some x -> [ "boost", `Float x ]
      in
      `Assoc [
        "constant_score", `Assoc (
          b @ ["filter", json_of_filter q];
        )
      ]

  | Date_range (name, from, to_, boost) ->
    let fields = with_boost ~cst_score boost [
      "from", `String from;
      "to", `String to_;
      "include_lower", `Bool true;
      "include_upper", `Bool true;
    ] in
    `Assoc ["range", `Assoc [name, `Assoc fields]]

  | Date_from (name, from, boost) ->
    let fields = with_boost ~cst_score boost [
      "from", `String from;
      "include_lower", `Bool true;
    ] in
    `Assoc ["range", `Assoc [name, `Assoc fields]]

  | Date_to (name, to_, boost) ->
    let fields = with_boost ~cst_score boost [
      "to", `String to_;
      "include_upper", `Bool true;
    ] in
    `Assoc ["range", `Assoc [name, `Assoc fields]]

  | Filter (q, f) ->
      `Assoc [
        "filtered", `Assoc [
          "query", to_json_ast ~cst_score q;
          "filter", json_of_filter f;
        ]
      ]

  | Parent (parent_type, with_score, q) ->
      let score_type =
        if with_score then "score"
        else "none"
      in
      `Assoc [
        "has_parent", `Assoc [
          "parent_type", `String parent_type;
          "score_type", `String score_type (* elasticsearch >= 0.20.2 *);
          "query", to_json_ast ~cst_score q;
        ]
      ]

and json_of_filter = function

  | Term_filter (name, s) ->
      `Assoc [
        "term", `Assoc [
          name, `String s
        ]
      ]

  | Geo_distance_filter (name, {lat; lon}, radius) ->
      `Assoc [
        "geo_distance", `Assoc [
          "distance", `String (sprintf "%gkm" radius);
          name, `Assoc [
            "lat", `Float lat;
            "lon", `Float lon;
          ]
        ]
      ]

  | Numeric_range_filter (name, opt_mini, opt_maxi) ->
      let l =
        match opt_mini, opt_maxi with
            None, None -> []
          | Some mini, None -> [ "gte", `Int mini ]
          | None, Some maxi -> [ "lte", `Int maxi ]
          | Some mini, Some maxi ->
              [
                "from", `Int mini;
                "to", `Int maxi;
                "include_lower", `Bool true;
                "include_upper", `Bool true;
              ]
      in
      `Assoc [
        "numeric_range", `Assoc [
          name, `Assoc l
        ]
      ]

  | And_filter l ->
      `Assoc [
        "and", `List (List.map json_of_filter l)
      ]

  | Or_filter l ->
      `Assoc [
        "or", `List (List.map json_of_filter l)
      ]

  | Not_filter q ->
      `Assoc [
        "not", json_of_filter q
      ]

  | Exists_filter name ->
      `Assoc [
        "exists", `Assoc [ "field", `String name ]
      ]

  | Missing_filter name ->
      `Assoc [
        "missing", `Assoc [
          "field", `String name;
          "null_value", `Bool true; (* nulls are treated as missing *)
        ]
      ]

  | Document_type s ->
      `Assoc [
        "type", `Assoc [
          "value", `String s
        ]
      ]

  | Query q ->
      `Assoc [
        "query", to_json_ast ~cst_score:true q
      ]

let to_json ~pretty q =
  let j = to_json_ast ~cst_score:false q in
  if pretty then
    Yojson.Basic.pretty_to_string ~std:true j
  else
    Yojson.Basic.to_string ~std:true j
