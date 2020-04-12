# program binaries
JULIA=julia
SCAD=openscad
# source directories
JULIASRC=src
SCADSRC=scad
# export destination directory
DESTDIR=build
# parameter file
PARAMSFILE=$(DESTDIR)/flute.json
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
all: head body foot

.PHONY: head
head: $(DESTDIR)/head.3mf

.PHONY: body
body: params $(DESTDIR)/body.3mf

.PHONY: foot
foot: params $(DESTDIR)/foot.3mf

.PHONY: params
params: $(PARAMSFILE)

# 3mf scad file dependencies
include $(wildcard $(DESTDIR)/*.3mf.mk)

# run optimization to generate parameters
$(PARAMSFILE): $(JULIASRC)/*.jl $(JULIASRC)/lib/*.jl
	@mkdir -pv $(DESTDIR)
	$(JULIA) $(JULIASRC)/optimize.jl $@

# compile scad to 3mf
$(DESTDIR)/%.3mf: $(SCADSRC)/%.scad
	@mkdir -pv $(DESTDIR)
	$(SCAD) $< -q -p $(PARAMSFILE) -P $(notdir $@).p -m $(MAKE) -d $@.mk -o $@ $(subst $$,\$$,$(value SCADFLAGS))

# clean build
.PHONY: clean
clean:
	@rm $(DESTDIR)/*.3mf.mk -fv
	@rm $(PARAMSFLIE) -fv
