PARSERGEN = _build/bin/parsergen
MELANGE = _build/bin/melange

.PHONY: parsergen melange check clean all

all: melange
parsergen: $(PARSERGEN)
melange: $(MELANGE)

$(PARSERGEN):
	dylan-compiler -build parsergen

melange-core/c-parse.dylan: melange-core/c-parse.input $(PARSERGEN)
	$(PARSERGEN) melange-core/c-parse.input melange-core/c-parse.dylan

melange/int-parse.dylan: melange/int-parse.input $(PARSERGEN)
	$(PARSERGEN) melange/int-parse.input melange/int-parse.dylan

$(MELANGE): melange-core/c-parse.dylan melange/int-parse.dylan
	dylan-compiler -build melange

check: $(MELANGE)
	@echo "All is well."

clean:
	rm -rf _build
	rm -f melange-core/c-parse.dylan
	rm -f melange/int-parse.dylan

