
PREFIX=../build
export

.PHONY: all
all: head.3mf body.3mf foot.3mf

# compile 3mf from scad
%.3mf: %.scad lib/*.scad
	@mkdir -p $(PREFIX)
	openscad $< -q -o $(PREFIX)/$@ $(subst $$,\$$,$(value SFLAGS))

# must manually clean head.3mf
.PHONY: clean
clean:
	@rm -fv $(PREFIX)/head.3mf
	@rm -fv $(PREFIX)/body.3mf
	@rm -fv $(PREFIX)/foot.3mf
