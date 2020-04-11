# build path
PREFIX=build
include flute.mk
export

.PHONY: all
all: flute.mk $(PREFIX)/head.3mf $(PREFIX)/body.3mf $(PREFIX)/foot.3mf

.PHONY: head
head: flute.mk $(PREFIX)/head.3mf

.PHONY: body
body: flute.mk $(PREFIX)/body.3mf

.PHONY: foot
foot: flute.mk $(PREFIX)/foot.3mf

.PHONY: $(PREFIX)/%.3mf
$(PREFIX)/%.3mf: flute.mk
	@$(MAKE) -C scad $(notdir $@) PREFIX=$(abspath $(PREFIX))

flute.mk:
	@$(MAKE) -C src flute.mk PREFIX=..

.PHONY: config
config:
	@$(MAKE) -B flute.mk
