type field_type =
| Text
| Token
| Binary
| Integer
| Long
| Float
| Double
| Byte
| Boolean
| Null
| Geo_point
| Date
| Array of field_type
| Object of field_mapping list

and field_mapping = {
  field_name : string;
  field_type : field_type;
  field_indexed : bool;
}

let field ?indexed:(field_indexed = true) field_name field_type = {
  field_name;
  field_type;
  field_indexed;
}

type doc_parent = {
  parent_type : string;
  parent_id_path : string;
}

type doc_mapping = {
  doc_type : string;
  doc_parent : doc_parent option;
  doc_all_field : bool;
  doc_indexed_fields : field_mapping list;
}

let index s = ("index", `String s)
let type_ s = ("type", `String s)

type index_option =
    Docs (* index only internal doc ID *)
  | Freqs (* default, store term frequency *)
  | Positions (* store term frequency and position *)

(* Options for indexing strings *)
let index_options x =
  let s =
    match x with
      | Docs -> "docs"
      | Freqs -> "freqs"
      | Positions -> "positions"
  in
  "index_options", `String s

let rec json_of_indexed_field x : string * Yojson.Basic.json =
  let name = x.field_name in
  assert (name <> "" && name.[0] <> '_');
  let param = json_of_field_type x.field_indexed x.field_type in
  (name, `Assoc param)

and json_of_field_type indexed t =
  let idx =
    if not indexed then [ index "no" ]
    else []
  in
  match t with
    | Text -> [ type_ "string" ] @ idx
    | Token ->
        let idx =
          if indexed then [
            index "not_analyzed";
            index_options Docs; (* ignore term frequencies *)
          ]
          else idx
        in
        [ type_ "string" ] @ idx
    | Binary -> [ type_ "binary" ] @ idx
    | Integer -> [ type_ "integer" ] @ idx
    | Long -> [ type_ "long" ] @ idx
    | Float -> [ type_ "float" ] @ idx
    | Double -> [ type_ "double" ] @ idx
    | Byte -> [ type_ "byte" ] @ idx
    | Boolean -> [ type_ "boolean" ] @ idx
    | Null -> [ type_ "null" ] @ idx
    | Geo_point -> [ type_ "geo_point"; "lat_lon", `Bool true ] @ idx
    | Date -> [ type_ "date" ] @ idx
    | Array x -> (* magic! *) json_of_field_type indexed x
    | Object l -> json_of_object l

and json_of_object l =
  [ "properties", `Assoc (List.map json_of_indexed_field l) ]

let to_json_ast x =
  let parent =
    match x.doc_parent with
        None -> []
      | Some p ->
          [ "_parent", `Assoc [ "type", `String p.parent_type ];
            "_routing", `Assoc [ "required", `Bool true;
                                 "path", `String p.parent_id_path ] ]
  in
  let indexed =
    let l = List.map json_of_indexed_field x.doc_indexed_fields in
    [ "_all", `Assoc [ "enabled", `Bool x.doc_all_field ];
      "dynamic", `Bool false; (* prevents indexing of undefined fields *)
      "properties", `Assoc l ]
  in
  `Assoc [
    x.doc_type, `Assoc (parent @ indexed)
  ]

let to_json ~pretty x =
  let j = to_json_ast x in
  if pretty then Yojson.Basic.pretty_to_string j
  else Yojson.Basic.to_string j
