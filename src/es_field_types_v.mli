(* Auto-generated from "es_field_types.atd" *)


type utf8 = Es_field_types_t.utf8

type base64 = Es_field_types_t.base64

type text = Es_field_types_t.text

type token = Es_field_types_t.token

type binary = Es_field_types_t.binary

type integer = Es_field_types_t.integer

type byte = Es_field_types_t.byte

type boolean = Es_field_types_t.boolean

type null = Es_field_types_t.null

type coord = Es_field_types_t.coord = { lat: float; lon: float }

type date = Es_field_types_t.date

type 'a array = 'a Es_field_types_t.array

val validate_utf8 :
  Ag_util.Validation.path -> utf8 -> Ag_util.Validation.error option
  (** Validate a value of type {!utf8}. *)

val validate_base64 :
  Ag_util.Validation.path -> base64 -> Ag_util.Validation.error option
  (** Validate a value of type {!base64}. *)

val validate_text :
  Ag_util.Validation.path -> text -> Ag_util.Validation.error option
  (** Validate a value of type {!text}. *)

val validate_token :
  Ag_util.Validation.path -> token -> Ag_util.Validation.error option
  (** Validate a value of type {!token}. *)

val validate_binary :
  Ag_util.Validation.path -> binary -> Ag_util.Validation.error option
  (** Validate a value of type {!binary}. *)

val validate_integer :
  Ag_util.Validation.path -> integer -> Ag_util.Validation.error option
  (** Validate a value of type {!integer}. *)

val validate_byte :
  Ag_util.Validation.path -> byte -> Ag_util.Validation.error option
  (** Validate a value of type {!byte}. *)

val validate_boolean :
  Ag_util.Validation.path -> boolean -> Ag_util.Validation.error option
  (** Validate a value of type {!boolean}. *)

val validate_null :
  Ag_util.Validation.path -> null -> Ag_util.Validation.error option
  (** Validate a value of type {!null}. *)

val create_coord :
  lat: float ->
  lon: float ->
  unit -> coord
  (** Create a record of type {!coord}. *)

val validate_coord :
  Ag_util.Validation.path -> coord -> Ag_util.Validation.error option
  (** Validate a value of type {!coord}. *)

val validate_date :
  Ag_util.Validation.path -> date -> Ag_util.Validation.error option
  (** Validate a value of type {!date}. *)

val validate_array :
  (Ag_util.Validation.path -> 'a -> Ag_util.Validation.error option) ->
  Ag_util.Validation.path -> 'a array -> Ag_util.Validation.error option
  (** Validate a value of type {!array}. *)

