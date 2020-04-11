# program binaries
JULIA=julia
SCAD=openscad
# source directories
JULIASRC=src
SCADSRC=scad
# export destination directory
DESTDIR=build
# extra openscad build arguments
SCADFLAGS=

export
SHELL=/bin/sh

# default target "all"
.PHONY: all
all: $(DESTDIR)/head.3mf $(DESTDIR)/body.3mf $(DESTDIR)/foot.3mf

# scad file dependencies (generated)
include $(wildcard $(DESTDIR)/*.deps)

# compile scad to 3mf
$(DESTDIR)/%.3mf: $(SCADSRC)/%.scad
	@mkdir -pv $(DESTDIR)
	$(SCAD) $< -q -m $(MAKE) -d $@.deps -o $@ $(subst $$,\$$,$(value SCADFLAGS))

# clean build
.PHONY: clean
clean:
	@rm $(DESTDIR)/*.deps -fv
