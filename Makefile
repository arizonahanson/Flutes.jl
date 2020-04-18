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
COLORSCHEME=Starnight
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
all: previews models

.PHONY: previews
previews: $(DESTDIR)/head.png $(DESTDIR)/body.png $(DESTDIR)/foot.png

.PHONY: models
models: $(DESTDIR)/head.3mf $(DESTDIR)/body.3mf $(DESTDIR)/foot.3mf

.PHONY: head
head: $(DESTDIR)/head.3mf $(DESTDIR)/head.png

.PHONY: body
body: $(DESTDIR)/body.3mf $(DESTDIR)/body.png

.PHONY: foot
foot: $(DESTDIR)/foot.3mf $(DESTDIR)/foot.png

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
	@echo -e " * Exporting 3D model: "$@
	@$(SCAD) $< -q \
		-p $(PARAMSFILE) -P $(notdir $(@:.3mf=.data)) \
		-d $(@:.3mf=.mk) -m $(MAKE) \
		-o $@ $(subst $$,\$$,$(value SCADFLAGS))
	@echo -e " * Complete: "$@

# compile scad to preview png
$(DESTDIR)/%.png: $(SCADSRC)/%.scad $(PARAMSFILE)
	@mkdir -pv $(DESTDIR)
	@echo -e " * Rendering preview: "$@
	@$(SCAD) $< -q \
		-p $(PARAMSFILE) -P $(notdir $(@:.png=.data)) \
		-d $(@:.png=.mk) -m $(MAKE) \
		--colorscheme=$(COLORSCHEME) \
		--imgsize=960,1080 \
		-o $@ $(subst $$,\$$,$(value SCADFLAGS))
	@echo -e " * Preview: "$@

# clean build
.PHONY: clean
clean:
	@rm $(DESTDIR)/head.mk $(DESTDIR)/body.mk $(DESTDIR)/foot.mk -fv
	@rm $(PARAMSFILE) -fv
