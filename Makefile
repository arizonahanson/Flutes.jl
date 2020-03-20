
.PHONY: default
default: all

.PHONY: all
all: head.stl body.stl foot.stl

# compile stl from scad
%.stl: parts/%.scad
	@echo "making" $@
	openscad $< -o $@ $(value ARGS)

.PHONY: clean
clean:
	@git clean -fxd
