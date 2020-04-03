# build path
PREFIX=build
include $(PREFIX)/flute.mk
export

.PHONY: all
all: $(PREFIX)/flute.mk $(PREFIX)/head.stl $(PREFIX)/body.stl $(PREFIX)/foot.stl

$(PREFIX)/%.stl:
	@$(MAKE) -C scad $(notdir $@) PREFIX=$(abspath $(PREFIX))

$(PREFIX)/flute.mk:
	@$(MAKE) -C src $(notdir flute.mk) PREFIX=$(abspath $(PREFIX))

.PHONY: config
config:
	@$(MAKE) -B $(PREFIX)/flute.mk

.PHONY: clean
clean:
	@$(MAKE) -C src clean PREFIX=$(abspath $(PREFIX))
	@$(MAKE) -C scad clean PREFIX=$(abspath $(PREFIX))

