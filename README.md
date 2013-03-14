ocaml-elasticsearch
=========

Elasticsearch client for OCaml


Requirements
------------

- `netstring`
- `batteries`
- `atdgen`
- `utf8val` (Available here: `https://github.com/mrnumber/utf8val`)


Installation
------------

```
$ make && make install
```

Usage
-------

Define a module by parameterizing Es_client with an HTTP client, connection configuration and index serialization settings:

```
open Es_client_t

module HttpClient_lwt =
struct
  type uri = string
  type response = (int * (string * string) list * string)
  type 'a computation = 'a Lwt.t
  let bind = Lwt.bind
  let return = Lwt.return
  let head ?headers s = (* ... *)
  let get ?headers s = (* ... *)
  let post ?headers ?body s = (* ... *)
  let put ?headers ?body s = (* ... *)
  let delete ?headers s = (* ... *)
end
module Host_and_port = struct
  let host () = "localhost"
  let port () = 9200
end
module Document_type = struct
  type t = Document_t.document
  let read ~doc_type = Document_j.read_document
  let write = Document_j.write_document
end
module ES_documents = Es_client.Make
  (HttpClient_lwt)
  (Host_and_port)
  (Document_type)
```

Create an index with mapping and index a document:

```
open Es_mapping

let index = "documents"
let document = [
  field id Token;
  field contents Text;
  field created_ts Date
]
let document_mapping = {
  doc_type = "document";
  doc_parent = None;
  doc_all_field = false;
  doc_indexed_fields = document;
}
let mappings = [ document_mapping ]
ES_documents.create_index ~shards:5 ~replicas:3 index mappings ();

let document = { id = "123"; contents = "foo"; created_ts = Unix.gettimeofday () }
ES_documents.index_item
    ~index
    ~mapping: document_mapping.doc_type
    ~id: document.id
    ~item: document
    ()
```

Get an item and perform a search:

```
ES_documents.get_items ~index ~mapping: document_mapping.doc_type ["123"];
ES_documents.search
    ~indexes:[index]
    ~mappings:[document_mapping.doc_type]
    ~from:0 ~size:100
    Match_all
```


TODO
----

* Add full support for Elasticsearch API
