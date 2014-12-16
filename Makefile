PARSERGEN = _build/bin/parsergen
MELANGE = _build/bin/melange
DESTDIR ?= /usr/local
INSTALLDIR = $(DESTDIR)/libexec/melange
GENERATED_PARSERS=melange-core/c-parse.dylan melange/int-parse.dylan

.PHONY: parsergen melange check clean all

all: melange
parsergen: $(PARSERGEN)
melange: $(MELANGE)

$(PARSERGEN): $(wildcard parsergen/*.dylan)
	dylan-compiler -build parsergen

melange-core/c-parse.dylan: melange-core/c-parse.input $(PARSERGEN)
	$(PARSERGEN) melange-core/c-parse.input melange-core/c-parse.dylan

melange/int-parse.dylan: melange/int-parse.input $(PARSERGEN)
	$(PARSERGEN) melange/int-parse.input melange/int-parse.dylan

$(MELANGE): $(GENERATED_PARSERS) $(wildcard melange/*.dylan) $(wildcard melange-core/*.dylan)
	dylan-compiler -build melange

check: $(MELANGE)
	@cd tests && ./run.sh

clean:
	rm -rf _build
	rm -f melange-core/c-parse.dylan
	rm -f melange/int-parse.dylan

install: melange
	install -d $(INSTALLDIR) $(INSTALLDIR)/bin $(INSTALLDIR)/lib
	cp -rp _build/bin/melange* $(INSTALLDIR)/bin
	cp -rp _build/lib/* $(INSTALLDIR)/lib
	install -d $(DESTDIR)/bin
	ln -sf $(INSTALLDIR)/bin/melange $(DESTDIR)/bin/melange
