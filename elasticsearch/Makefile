.PHONY: default all byte opt install reinstall uninstall clean

default: byte opt

all: byte
byte: elasticsearch.cma
opt: elasticsearch.cmxa

PACKAGES = netstring-light utf8val atdgen

ATDGEN_SOURCES = es_field_types.atd es_client.atd
ATDGEN_FLAGS = -j-std
include ../Atdgen.mk

OCAML_FILES = \
  es_field_types_t.mli es_field_types_t.ml \
  es_field_types_j.mli es_field_types_j.ml \
  es_field_types_v.mli es_field_types_v.ml \
  es_untyped_json.ml \
  es_client_t.mli es_client_t.ml \
  es_client_j.mli es_client_j.ml \
  es_client_v.mli es_client_v.ml \
  es_error.ml \
  es_mapping.mli es_mapping.ml \
  es_query.ml \
  es_client.mli es_client.ml

elasticsearch.cma: $(OCAML_FILES)
	ocamlfind ocamlc -a -o $@ -g -annot \
          $(OCAML_FILES) \
          -package "$(PACKAGES)" -linkpkg

elasticsearch.cmxa: $(OCAML_FILES)
	ocamlfind opt -o $@ -g -annot \
          $(OCAML_FILES) \
          -package "$(PACKAGES)" -linkpkg

install:
	ocamlfind install elasticsearch META \
          $$(ls *.cm[ix] *.o *.mli \
                es_untyped_json.ml es_error.ml es_query.ml \
                elasticsearch.cma elasticsearch.cmxa elasticsearch.a)

uninstall:
	ocamlfind remove elasticsearch

reinstall:
	-$(MAKE) uninstall
	$(MAKE) install

clean:
	rm -f *.o *.a *.cm* *~ *.annot $(ATDGEN_OUTFILES) elastictest
