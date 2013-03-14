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

let write_utf8 = (
  Yojson.Safe.write_string
)
let string_of_utf8 ?(len = 1024) x =
  let ob = Bi_outbuf.create len in
  write_utf8 ob x;
  Bi_outbuf.contents ob
let read_utf8 = (
  Ag_oj_run.read_string
)
let utf8_of_string s =
  read_utf8 (Yojson.Safe.init_lexer ()) (Lexing.from_string s)
let write_base64 = (
  Yojson.Safe.write_string
)
let string_of_base64 ?(len = 1024) x =
  let ob = Bi_outbuf.create len in
  write_base64 ob x;
  Bi_outbuf.contents ob
let read_base64 = (
  Ag_oj_run.read_string
)
let base64_of_string s =
  read_base64 (Yojson.Safe.init_lexer ()) (Lexing.from_string s)
let write_text = (
  write_utf8
)
let string_of_text ?(len = 1024) x =
  let ob = Bi_outbuf.create len in
  write_text ob x;
  Bi_outbuf.contents ob
let read_text = (
  read_utf8
)
let text_of_string s =
  read_text (Yojson.Safe.init_lexer ()) (Lexing.from_string s)
let write_token = (
  write_utf8
)
let string_of_token ?(len = 1024) x =
  let ob = Bi_outbuf.create len in
  write_token ob x;
  Bi_outbuf.contents ob
let read_token = (
  read_utf8
)
let token_of_string s =
  read_token (Yojson.Safe.init_lexer ()) (Lexing.from_string s)
let write_binary = (
  write_base64
)
let string_of_binary ?(len = 1024) x =
  let ob = Bi_outbuf.create len in
  write_binary ob x;
  Bi_outbuf.contents ob
let read_binary = (
  read_base64
)
let binary_of_string s =
  read_binary (Yojson.Safe.init_lexer ()) (Lexing.from_string s)
let write_integer = (
  Yojson.Safe.write_int
)
let string_of_integer ?(len = 1024) x =
  let ob = Bi_outbuf.create len in
  write_integer ob x;
  Bi_outbuf.contents ob
let read_integer = (
  Ag_oj_run.read_int
)
let integer_of_string s =
  read_integer (Yojson.Safe.init_lexer ()) (Lexing.from_string s)
let write_byte = (
  Yojson.Safe.write_int
)
let string_of_byte ?(len = 1024) x =
  let ob = Bi_outbuf.create len in
  write_byte ob x;
  Bi_outbuf.contents ob
let read_byte = (
  Ag_oj_run.read_int
)
let byte_of_string s =
  read_byte (Yojson.Safe.init_lexer ()) (Lexing.from_string s)
let write_boolean = (
  Yojson.Safe.write_bool
)
let string_of_boolean ?(len = 1024) x =
  let ob = Bi_outbuf.create len in
  write_boolean ob x;
  Bi_outbuf.contents ob
let read_boolean = (
  Ag_oj_run.read_bool
)
let boolean_of_string s =
  read_boolean (Yojson.Safe.init_lexer ()) (Lexing.from_string s)
let write_null = (
  Yojson.Safe.write_null
)
let string_of_null ?(len = 1024) x =
  let ob = Bi_outbuf.create len in
  write_null ob x;
  Bi_outbuf.contents ob
let read_null = (
  Ag_oj_run.read_null
)
let null_of_string s =
  read_null (Yojson.Safe.init_lexer ()) (Lexing.from_string s)
let write_coord = (
  fun ob x ->
    Bi_outbuf.add_char ob '{';
    let is_first = ref true in
    if !is_first then
      is_first := false
    else
      Bi_outbuf.add_char ob ',';
    Bi_outbuf.add_string ob "\"lat\":";
    (
      Yojson.Safe.write_std_float
    )
      ob x.lat;
    if !is_first then
      is_first := false
    else
      Bi_outbuf.add_char ob ',';
    Bi_outbuf.add_string ob "\"lon\":";
    (
      Yojson.Safe.write_std_float
    )
      ob x.lon;
    Bi_outbuf.add_char ob '}';
)
let string_of_coord ?(len = 1024) x =
  let ob = Bi_outbuf.create len in
  write_coord ob x;
  Bi_outbuf.contents ob
let read_coord = (
  fun p lb ->
    Yojson.Safe.read_space p lb;
    Yojson.Safe.read_lcurl p lb;
    let x =
      {
        lat = Obj.magic 0.0;
        lon = Obj.magic 0.0;
      }
    in
    let bits0 = ref 0 in
    try
      Yojson.Safe.read_space p lb;
      Yojson.Safe.read_object_end lb;
      Yojson.Safe.read_space p lb;
      let f =
        fun s pos len ->
          if pos < 0 || len < 0 || pos + len > String.length s then
            invalid_arg "out-of-bounds substring position or length";
          if len = 3 && String.unsafe_get s pos = 'l' then (
            match String.unsafe_get s (pos+1) with
              | 'a' -> (
                  if String.unsafe_get s (pos+2) = 't' then (
                    0
                  )
                  else (
                    -1
                  )
                )
              | 'o' -> (
                  if String.unsafe_get s (pos+2) = 'n' then (
                    1
                  )
                  else (
                    -1
                  )
                )
              | _ -> (
                  -1
                )
          )
          else (
            -1
          )
      in
      let i = Yojson.Safe.map_ident p f lb in
      Ag_oj_run.read_until_field_value p lb;
      (
        match i with
          | 0 ->
            let v =
              (
                Ag_oj_run.read_number
              ) p lb
            in
            Obj.set_field (Obj.repr x) 0 (Obj.repr v);
            bits0 := !bits0 lor 0x1;
          | 1 ->
            let v =
              (
                Ag_oj_run.read_number
              ) p lb
            in
            Obj.set_field (Obj.repr x) 1 (Obj.repr v);
            bits0 := !bits0 lor 0x2;
          | _ -> (
              Yojson.Safe.skip_json p lb
            )
      );
      while true do
        Yojson.Safe.read_space p lb;
        Yojson.Safe.read_object_sep p lb;
        Yojson.Safe.read_space p lb;
        let f =
          fun s pos len ->
            if pos < 0 || len < 0 || pos + len > String.length s then
              invalid_arg "out-of-bounds substring position or length";
            if len = 3 && String.unsafe_get s pos = 'l' then (
              match String.unsafe_get s (pos+1) with
                | 'a' -> (
                    if String.unsafe_get s (pos+2) = 't' then (
                      0
                    )
                    else (
                      -1
                    )
                  )
                | 'o' -> (
                    if String.unsafe_get s (pos+2) = 'n' then (
                      1
                    )
                    else (
                      -1
                    )
                  )
                | _ -> (
                    -1
                  )
            )
            else (
              -1
            )
        in
        let i = Yojson.Safe.map_ident p f lb in
        Ag_oj_run.read_until_field_value p lb;
        (
          match i with
            | 0 ->
              let v =
                (
                  Ag_oj_run.read_number
                ) p lb
              in
              Obj.set_field (Obj.repr x) 0 (Obj.repr v);
              bits0 := !bits0 lor 0x1;
            | 1 ->
              let v =
                (
                  Ag_oj_run.read_number
                ) p lb
              in
              Obj.set_field (Obj.repr x) 1 (Obj.repr v);
              bits0 := !bits0 lor 0x2;
            | _ -> (
                Yojson.Safe.skip_json p lb
              )
        );
      done;
      assert false;
    with Yojson.End_of_object -> (
        if !bits0 <> 0x3 then Ag_oj_run.missing_fields [| !bits0 |] [| "lat"; "lon" |];
        Ag_oj_run.identity x
      )
)
let coord_of_string s =
  read_coord (Yojson.Safe.init_lexer ()) (Lexing.from_string s)
let write_date = (
  Yojson.Safe.write_string
)
let string_of_date ?(len = 1024) x =
  let ob = Bi_outbuf.create len in
  write_date ob x;
  Bi_outbuf.contents ob
let read_date = (
  Ag_oj_run.read_string
)
let date_of_string s =
  read_date (Yojson.Safe.init_lexer ()) (Lexing.from_string s)
let write__1 write__a = (
  Ag_oj_run.write_list (
    write__a
  )
)
let string_of__1 write__a ?(len = 1024) x =
  let ob = Bi_outbuf.create len in
  write__1 write__a ob x;
  Bi_outbuf.contents ob
let read__1 read__a = (
  Ag_oj_run.read_list (
    read__a
  )
)
let _1_of_string read__a s =
  read__1 read__a (Yojson.Safe.init_lexer ()) (Lexing.from_string s)
let write_array write__a = (
  write__1 write__a
)
let string_of_array write__a ?(len = 1024) x =
  let ob = Bi_outbuf.create len in
  write_array write__a ob x;
  Bi_outbuf.contents ob
let read_array read__a = (
  read__1 read__a
)
let array_of_string read__a s =
  read_array read__a (Yojson.Safe.init_lexer ()) (Lexing.from_string s)
