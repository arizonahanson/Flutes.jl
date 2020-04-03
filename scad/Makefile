
PREFIX=../build
export

.PHONY: all
all: head.stl body.stl foot.stl

# compile stl from scad
%.stl: %.scad lib/*.scad
	@mkdir -p $(PREFIX)
	openscad $< -q -o $(PREFIX)/$@ $(subst $$,\$$,$(value SFLAGS))

# must manually clean head.stl
.PHONY: clean
clean:
	@rm -fv $(PREFIX)/head.stl
	@rm -fv $(PREFIX)/body.stl
	@rm -fv $(PREFIX)/foot.stl
