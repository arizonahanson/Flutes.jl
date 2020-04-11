SHELL=/bin/sh
JULIA=julia
JULIASRC=src
SCAD=openscad
SCADSRC=scad
DESTDIR=build
export

.PHONY: all
all: $(DESTDIR)/head.3mf $(DESTDIR)/body.3mf $(DESTDIR)/foot.3mf

# scad file dependencies (generated)
include $(wildcard $(DESTDIR)/*.deps)

# compile 3mf from scad
$(DESTDIR)/%.3mf: $(SCADSRC)/%.scad
	@mkdir -pv $(DESTDIR)
	$(SCAD) $< -q -m $(MAKE) -d $@.deps -o $@ $(subst $$,\$$,$(value SCADFLAGS))

# clean build
.PHONY: clean
clean:
	@rm $(DESTDIR)/*.deps -fv
