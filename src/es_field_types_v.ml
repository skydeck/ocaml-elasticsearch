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

let validate_utf8 = (
  fun path s ->
      if Utf8val.is_allowed_unicode s then None
      else
        let msg =
          Printf.sprintf "Malformed UTF-8: %S"
            (if String.length s <= 100 then s
             else String.sub s 0 100 ^ " ...")
        in
        Some (Ag_util.Validation.error ~msg path)
)
let validate_base64 = (
  fun path s ->
      try ignore (Nlencoding.Base64.decode s); None
      with _ ->
        let msg = Printf.sprintf "Malformed base64 %S" s in
        Some (Ag_util.Validation.error ~msg path)
)
let validate_text = (
  validate_utf8
)
let validate_token = (
  validate_utf8
)
let validate_binary = (
  validate_base64
)
let validate_integer = (
  (fun _ _ -> None)
)
let validate_byte = (
  fun path x ->
       if x >= 0 && x <= 255 then None
       else
         let msg = Printf.sprintf "Not a byte: %i" x in
         Some (Ag_util.Validation.error ~msg path)
)
let validate_boolean = (
  (fun _ _ -> None)
)
let validate_null = (
  (fun _ _ -> None)
)
let validate_coord = (
  fun path x ->
    match
      (
        fun path x ->
        if x >= -90. && x <= 90. then None
        else
          let msg =
            Printf.sprintf "Latitude out of range [-90, 90]: %g" x
          in
          Some (Ag_util.Validation.error ~msg path)
      ) (`Field "lat" :: path) x.lat
    with
      | Some _ as err -> err
      | None ->
        (
          
      fun path x ->
        if x >= -180. && x <= 180. then None
        else
          let msg =
            Printf.sprintf "Longitude out of range [-180, 180]: %g" x
          in
          Some (Ag_util.Validation.error ~msg path)
        ) (`Field "lon" :: path) x.lon
)
let validate_date = (
  fun path s ->
      try ignore (Nldate.parse s); None
      with _ ->
        let msg = Printf.sprintf "Invalid date %S" s in
        Some (Ag_util.Validation.error ~msg path)
)
let validate__1 validate__a = (
  Ag_ov_run.validate_list (
    validate__a
  )
)
let validate_array validate__a = (
  validate__1 validate__a
)
let create_coord 
  ~lat
  ~lon
  () =
  {
    lat = lat;
    lon = lon;
  }
