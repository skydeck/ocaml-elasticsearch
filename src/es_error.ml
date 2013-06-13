open Printf

type error =
  | Http_failure
      (* could not get an HTTP response *)

  | Http_error of (int * (string * string) list * string)
      (* could not interpret the HTTP response *)

  | Elasticsearch_error of Es_client_t.generic_result
      (* parsable response from elasticsearch indicating an error *)

  | Data_error of string
      (* error indicating malformed data of some kind *)

exception Error of error

let string_of_http_resp (hr_status, hr_headers, hr_body) =
  Es_client_j.string_of_http_resp_record
    { Es_client_t.hr_status; hr_headers; hr_body }

let printer e =
  match e with
    | Error err ->
        let msg =
          match err with
              Http_failure ->
                "Es_error.Http_failure"
            | Http_error http_resp ->
                sprintf "Es_error.Http_error %s"
                  (string_of_http_resp http_resp)
            | Elasticsearch_error x ->
                let s = Es_client_j.string_of_generic_result x in
                sprintf "Es_error.Elasticseach_error %s" s
            | Data_error s ->
                sprintf "Es_error.Data_error (%s)" s
        in
        Some msg
    | _ ->
        None

(*
  Improve the output of Printexc.to_string
*)
let init =
  let once = lazy (Printexc.register_printer printer) in
  fun () -> Lazy.force once
