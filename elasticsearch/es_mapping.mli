(**
   This for module is for specifying how to index fields
   with elasticsearch, overriding the implicit settings.

   This is a simplified interface on top of elasticsearch's JSON API.
*)

type field_type =
| Text (** UTF-8 text will be tokenized; should work with any language. *)
| Token (** indexed as a single word or token, good for categories
            It must be UTF8-compatible because of JSON limitations.
            Use Binary and base64 encoding for non-UTF8 data. *)
| Binary (** base64-encoded arbitrary data *)
| Integer (** 32-bit signed integer *)
| Long (** default integer type (64-bit signed) *)
| Float (** 32-bit IEEE 754 *)
| Double (** default floating-point type (64-bit IEEE 754) *)
| Byte (** possibly more efficient than Integer *)
| Boolean (** true or false *)
| Null (** null value, i.e. the field is a simple flag *)
| Geo_point (** geographic coordinates enabling radius-search *)
| Date (** date_optional_time (RFC-3339 full-date or date-time) *)
| Array of field_type
| Object of field_mapping list

and field_mapping = {
  field_name : string;
  field_type : field_type;
  field_indexed : bool;
}

val field : ?indexed: bool -> string -> field_type -> field_mapping
  (** Create a field_mapping from field name and type.

      @param indexed whether the field should be indexed (default: true)
  *)

type doc_parent = {
  parent_type : string;
  parent_id_path : string;
    (* Indicates the path to the parent ID in the document.
       See elasticsearch guide, section "routing field" *)
}

type doc_mapping = {
  doc_type : string;
    (** Mapping type name.
        In order to create several mappings of the
        same type with different names, we have
        to change the type name. *)
  doc_parent : doc_parent option;
    (** Type of the parent document, if any
        (see elasticsearch documentation for '_parent'). *)
  doc_all_field : bool;
    (** Whether to enable the compound field '_all' *)
  doc_indexed_fields : field_mapping list;
}
  (** The configuration that tells elasticsearch how to index a document. *)


val to_json_ast : doc_mapping -> Yojson.Basic.json
val to_json : pretty: bool -> doc_mapping -> string
  (** elasticsearch-compliant definition of a mapping
      (how to index a type of document) *)
