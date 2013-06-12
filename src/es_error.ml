exception Http_failure
  (* could not get an HTTP response *)

exception Http_error of (int * (string * string) list * string)
  (* could not interpret the HTTP response *)

exception Elasticsearch_error of Es_client_t.generic_result
  (* parsable response from elasticsearch indicating an error *)

exception Data_error of string
  (* error indicating malformed data of some kind *)
