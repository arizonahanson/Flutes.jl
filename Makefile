# build path
PREFIX=build
include flute.mk
export

.PHONY: all
all: flute.mk $(PREFIX)/head.stl $(PREFIX)/body.stl $(PREFIX)/foot.stl

.PHONY: head
head: flute.mk $(PREFIX)/head.stl

.PHONY: body
body: flute.mk $(PREFIX)/body.stl

.PHONY: foot
foot: flute.mk $(PREFIX)/foot.stl

.PHONY: $(PREFIX)/%.stl
$(PREFIX)/%.stl: flute.mk
	@$(MAKE) -C scad $(notdir $@) PREFIX=$(abspath $(PREFIX))

flute.mk:
	@$(MAKE) -C src flute.mk PREFIX=..

.PHONY: config
config:
	@$(MAKE) -B flute.mk
