# program binaries
JULIA=julia
SCAD=openscad
# source directories
JULIASRC=src
SCADSRC=scad
# export destination directory
DESTDIR=build
# scad parameter set file
PARAMSFILE=$(DESTDIR)/data.json
# extra openscad build arguments
SCADFLAGS=
# flute constraints
FLUTE_BREAK=3
FLUTE_SCALE=C♯5 B4 A4 G4 F♯4 E4 D4
FLUTE_MIN_DIAMETERS=2 2 2 2 2 2
FLUTE_MAX_DIAMETERS=9 9.5 9 9 10 9.5
FLUTE_MIN_PADDING=174 18 18 44 18 18
FLUTE_MAX_PADDING=Inf 40 35 Inf 35 35
export
SHELL=/bin/sh

# default target "all"
.PHONY: all
all: head body foot

.PHONY: head
head: $(DESTDIR)/head.3mf

.PHONY: body
body: $(DESTDIR)/body.3mf

.PHONY: foot
foot: $(DESTDIR)/foot.3mf

.PHONY: optimize
optimize: $(PARAMSFILE)

# run optimization to generate parameters
$(PARAMSFILE): $(JULIASRC)/*.jl $(JULIASRC)/lib/*.jl
	@mkdir -pv $(dir $@)
	@echo -e " * Optimizing flute parameters"
	@echo -e "    Output path: "$@"\n"
	@$(JULIA) $(JULIASRC)/optimize.jl $@

# 3mf scad file dependencies
include $(wildcard $(DESTDIR)/*.mk)
# compile scad to 3mf
$(DESTDIR)/%.3mf: $(SCADSRC)/%.scad $(PARAMSFILE)
	@mkdir -pv $(DESTDIR)
	@echo -e " * Rendering 3mf model\n    Output path: "$@"\n"
	@$(SCAD) $< -q \
		-p $(PARAMSFILE) -P $(notdir $(@:.3mf=.data)) \
		-d $(@:.3mf=.mk) -m $(MAKE) \
		-o $@ $(subst $$,\$$,$(value SCADFLAGS))
	@zip -q -j $@ $(PARAMSFILE)
	@echo -e " * Complete: "$@"\n"

# clean build
.PHONY: clean
clean:
	@rm $(DESTDIR)/*.mk -fv
	@rm $(PARAMSFILE) -fv
