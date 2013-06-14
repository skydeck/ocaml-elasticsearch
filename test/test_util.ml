open Printf

let prettify s =
  try "JSON\n" ^ Yojson.Basic.prettify s ^ "\n"
  with _ -> s

let print_req meth uri_s body =
  printf "Request %s %s\n" (Cohttp.Code.string_of_method meth) uri_s;
  (match body with
      None -> ()
    | Some s -> printf "Request body:\n%s\n" (prettify s);
  );
  flush stdout

let print_resp status body =
  printf "Response status: %s\n" (Cohttp.Code.string_of_status status);
  printf "Response body:\n%s\n" (prettify body);
  flush stdout

let wrap ?(headers = []) uri_s meth body =
  let uri = Uri.of_string uri_s in
  let headers = Cohttp.Header.of_list headers in
  let headers =
    match Cohttp.Header.get headers "content-length", body with
        None, Some s ->
          Cohttp.Header.add headers
            "content-length"
            (string_of_int (String.length s))
      | _ -> headers
  in
  let body =
    match body with
        None -> None
      | Some s -> Cohttp_lwt_unix.Body.body_of_string s
  in

  Lwt.bind
    (Cohttp_lwt_unix.Client.call ~headers ?body meth uri)
    (function
      | None -> Lwt.return None
      | Some (resp, body) ->
          Lwt.bind
            (Cohttp_lwt_unix.Body.string_of_body body)
            (fun body_string ->
              let status = Cohttp_lwt_unix.Response.status resp in
              let status_code = Cohttp.Code.code_of_status status in
              let resp_headers = Cohttp_lwt_unix.Response.headers resp in
              print_resp status body_string;
              Lwt.return (
                Some (
                  status_code,
                  Cohttp.Header.to_list resp_headers,
                  body_string
                )
              )
            )
    )

module Lwt_http_client =
struct
  type 'a computation = 'a Lwt.t
  let bind = Lwt.bind
  let return = Lwt.return

  let head ?headers url = wrap ?headers url `HEAD None
  let get ?headers url = wrap ?headers url `GET None
  let post ?headers ?body url = wrap ?headers url `POST body
  let put ?headers ?body url = wrap ?headers url `PUT body
  let delete ?headers url = wrap ?headers url `DELETE None
end
