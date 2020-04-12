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
# flute constraints
FLUTE_BREAK=3
FLUTE_SCALE=D4 E4 F♯4 G4 A4 B4 C♯5
FLUTE_MIN_DIAMETERS=2 2 2 2 2 2
FLUTE_MAX_DIAMETERS=9 9 9 9 9 9
FLUTE_MIN_PADDING=18 18 18 44 18 18
FLUTE_MAX_PADDING=Inf 40 35 Inf 35 40
export
SHELL=/bin/sh

# default target "all"
.PHONY: all
all: $(DESTDIR)/head.3mf $(DESTDIR)/body.3mf $(DESTDIR)/foot.3mf

# run optimization to generate parameters
$(DESTDIR)/params.json: $(JULIASRC)/*.jl $(JULIASRC)/lib/*.jl
	@mkdir -pv $(DESTDIR)
	$(JULIA) $(JULIASRC)/optimize.jl $@

# 3mf scad file dependencies
include $(wildcard $(DESTDIR)/*.3mf.deps)

# compile scad to 3mf
$(DESTDIR)/%.3mf: $(SCADSRC)/%.scad $(DESTDIR)/params.json
	@mkdir -pv $(DESTDIR)
	$(SCAD) $< -q -p $(DESTDIR)/params.json -P $(notdir $@).p -m $(MAKE) -d $@.deps -o $@ $(subst $$,\$$,$(value SCADFLAGS))

# clean build
.PHONY: clean
clean:
	@rm $(DESTDIR)/*.deps -fv
	@rm $(DESTDIR)/params.json -fv
