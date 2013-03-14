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

val write_utf8 :
  Bi_outbuf.t -> utf8 -> unit
  (** Output a JSON value of type {!utf8}. *)

val string_of_utf8 :
  ?len:int -> utf8 -> string
  (** Serialize a value of type {!utf8}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_utf8 :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> utf8
  (** Input JSON data of type {!utf8}. *)

val utf8_of_string :
  string -> utf8
  (** Deserialize JSON data of type {!utf8}. *)

val write_base64 :
  Bi_outbuf.t -> base64 -> unit
  (** Output a JSON value of type {!base64}. *)

val string_of_base64 :
  ?len:int -> base64 -> string
  (** Serialize a value of type {!base64}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_base64 :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> base64
  (** Input JSON data of type {!base64}. *)

val base64_of_string :
  string -> base64
  (** Deserialize JSON data of type {!base64}. *)

val write_text :
  Bi_outbuf.t -> text -> unit
  (** Output a JSON value of type {!text}. *)

val string_of_text :
  ?len:int -> text -> string
  (** Serialize a value of type {!text}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_text :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> text
  (** Input JSON data of type {!text}. *)

val text_of_string :
  string -> text
  (** Deserialize JSON data of type {!text}. *)

val write_token :
  Bi_outbuf.t -> token -> unit
  (** Output a JSON value of type {!token}. *)

val string_of_token :
  ?len:int -> token -> string
  (** Serialize a value of type {!token}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_token :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> token
  (** Input JSON data of type {!token}. *)

val token_of_string :
  string -> token
  (** Deserialize JSON data of type {!token}. *)

val write_binary :
  Bi_outbuf.t -> binary -> unit
  (** Output a JSON value of type {!binary}. *)

val string_of_binary :
  ?len:int -> binary -> string
  (** Serialize a value of type {!binary}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_binary :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> binary
  (** Input JSON data of type {!binary}. *)

val binary_of_string :
  string -> binary
  (** Deserialize JSON data of type {!binary}. *)

val write_integer :
  Bi_outbuf.t -> integer -> unit
  (** Output a JSON value of type {!integer}. *)

val string_of_integer :
  ?len:int -> integer -> string
  (** Serialize a value of type {!integer}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_integer :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> integer
  (** Input JSON data of type {!integer}. *)

val integer_of_string :
  string -> integer
  (** Deserialize JSON data of type {!integer}. *)

val write_byte :
  Bi_outbuf.t -> byte -> unit
  (** Output a JSON value of type {!byte}. *)

val string_of_byte :
  ?len:int -> byte -> string
  (** Serialize a value of type {!byte}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_byte :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> byte
  (** Input JSON data of type {!byte}. *)

val byte_of_string :
  string -> byte
  (** Deserialize JSON data of type {!byte}. *)

val write_boolean :
  Bi_outbuf.t -> boolean -> unit
  (** Output a JSON value of type {!boolean}. *)

val string_of_boolean :
  ?len:int -> boolean -> string
  (** Serialize a value of type {!boolean}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_boolean :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> boolean
  (** Input JSON data of type {!boolean}. *)

val boolean_of_string :
  string -> boolean
  (** Deserialize JSON data of type {!boolean}. *)

val write_null :
  Bi_outbuf.t -> null -> unit
  (** Output a JSON value of type {!null}. *)

val string_of_null :
  ?len:int -> null -> string
  (** Serialize a value of type {!null}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_null :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> null
  (** Input JSON data of type {!null}. *)

val null_of_string :
  string -> null
  (** Deserialize JSON data of type {!null}. *)

val write_coord :
  Bi_outbuf.t -> coord -> unit
  (** Output a JSON value of type {!coord}. *)

val string_of_coord :
  ?len:int -> coord -> string
  (** Serialize a value of type {!coord}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_coord :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> coord
  (** Input JSON data of type {!coord}. *)

val coord_of_string :
  string -> coord
  (** Deserialize JSON data of type {!coord}. *)

val write_date :
  Bi_outbuf.t -> date -> unit
  (** Output a JSON value of type {!date}. *)

val string_of_date :
  ?len:int -> date -> string
  (** Serialize a value of type {!date}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_date :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> date
  (** Input JSON data of type {!date}. *)

val date_of_string :
  string -> date
  (** Deserialize JSON data of type {!date}. *)

val write_array :
  (Bi_outbuf.t -> 'a -> unit) ->
  Bi_outbuf.t -> 'a array -> unit
  (** Output a JSON value of type {!array}. *)

val string_of_array :
  (Bi_outbuf.t -> 'a -> unit) ->
  ?len:int -> 'a array -> string
  (** Serialize a value of type {!array}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_array :
  (Yojson.Safe.lexer_state -> Lexing.lexbuf -> 'a) ->
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> 'a array
  (** Input JSON data of type {!array}. *)

val array_of_string :
  (Yojson.Safe.lexer_state -> Lexing.lexbuf -> 'a) ->
  string -> 'a array
  (** Deserialize JSON data of type {!array}. *)

