PACKAGES = cohttp.lwt elasticsearch

ATDGEN_SOURCES = test_mapping.atd
ATDGEN_FLAGS = -j-std
include ../Atdgen.mk

OCAML_FILES = \
  test_mapping_t.mli test_mapping_t.ml \
  test_mapping_j.mli test_mapping_j.ml \
  test_mapping_v.mli test_mapping_v.ml \
  test_util.ml \
  elastictest.ml

.PHONY: default
default: elastictest
elastictest: $(OCAML_FILES)
	OCAMLPATH=..:$(OCAMLPATH) ocamlfind opt -o $@ -g -annot \
          $(OCAML_FILES) \
          -package "$(PACKAGES)" -linkpkg

.PHONY: clean
clean:
	rm -f *.o *.a *.cm* *~ *.annot $(ATDGEN_OUTFILES) elastictest
