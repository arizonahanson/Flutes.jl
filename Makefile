# build path
PREFIX=build
include $(PREFIX)/flute.mk
export

.PHONY: all
all: $(PREFIX)/flute.mk
	@$(MAKE) -C scad head.stl body.stl foot.stl PREFIX=$(abspath $(PREFIX))

.PHONY: head
head: $(PREFIX)/flute.mk
	@$(MAKE) -C scad head.stl PREFIX=$(abspath $(PREFIX))

.PHONY: body
body: $(PREFIX)/flute.mk
	@$(MAKE) -C scad body.stl PREFIX=$(abspath $(PREFIX))

.PHONY: foot
foot: $(PREFIX)/flute.mk
	@$(MAKE) -C scad foot.stl PREFIX=$(abspath $(PREFIX))

.PHONY: config
config:
	@$(MAKE) -C src flute.mk PREFIX=$(abspath $(PREFIX))

$(PREFIX)/flute.mk:
	@$(MAKE) -C src flute.mk PREFIX=$(abspath $(PREFIX))

.PHONY: clean
clean:
	@$(MAKE) -C src clean PREFIX=$(abspath $(PREFIX))
	@$(MAKE) -C scad clean PREFIX=$(abspath $(PREFIX))

