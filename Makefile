# build path
PREFIX=build
include $(PREFIX)/flute.mk
export

.PHONY: all
all: $(PREFIX)/flute.mk $(PREFIX)/head.stl $(PREFIX)/body.stl $(PREFIX)/foot.stl

.PHONY: head
head: $(PREFIX)/flute.mk $(PREFIX)/head.stl

.PHONY: body
body: $(PREFIX)/flute.mk $(PREFIX)/body.stl

.PHONY: foot
foot: $(PREFIX)/flute.mk $(PREFIX)/foot.stl

.PHONY: $(PREFIX)/%.stl
$(PREFIX)/%.stl: $(PREFIX)/flute.mk
	@$(MAKE) -C scad $(notdir $@) PREFIX=$(abspath $(PREFIX))

.PHONY: $(PREFIX)/flute.mk
$(PREFIX)/flute.mk:
	@$(MAKE) -C src $(notdir flute.mk) PREFIX=$(abspath $(PREFIX))

.PHONY: config
config:
	@$(MAKE) -B $(PREFIX)/flute.mk

.PHONY: clean
clean:
	@$(MAKE) -C src clean PREFIX=$(abspath $(PREFIX))
	@$(MAKE) -C scad clean PREFIX=$(abspath $(PREFIX))

