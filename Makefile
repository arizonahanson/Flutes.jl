
# example: make foot ARGS='-D$fd=0.4 -D$fl=0.162'
#
DEPS=parts/consts.scad parts/tenon.scad parts/tools.scad

.PHONY: all
all: head body foot

.PHONY: head
head: head.stl

.PHONY: body
body: body.stl

.PHONY: foot
foot: foot.stl

# compile stl from scad
%.stl: parts/%.scad $(DEPS)
	@echo "making" $@
	openscad $< -o $@ $(subst $$,\$$,$(value ARGS))

.PHONY: clean
clean:
	@git clean -fxd
