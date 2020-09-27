# flute constraints
FLUTE_SCALE=C♯5 B4 A4 G4 F♯4 E4 D4
FLUTE_MIN_DIAMETERS=4 4 4 4 4 4
FLUTE_MAX_DIAMETERS=9 10 9 9 10 9
FLUTE_MIN_PADDING=165 18 18 35 18 18
FLUTE_MAX_PADDING=Inf 35 30 Inf 35 30
FLUTE_HOLE_ROTATIONS=0 10 0 0 -10 0
FLUTE_BREAK=3
FLUTE_TUNING=440.0
TRACE=false
export
# program binaries
JULIA=docker run -it --rm \
			-e FLUTE_SCALE \
			-e FLUTE_TUNING \
			-e FLUTE_MIN_DIAMETERS \
			-e FLUTE_MAX_DIAMETERS \
			-e FLUTE_MIN_PADDING \
			-e FLUTE_MAX_PADDING \
			-e FLUTE_HOLE_ROTATIONS \
			-e FLUTE_BREAK \
			-e TRACE \
			-v "$(PWD)":/Flutes.jl -w /Flutes.jl workshop:latest julia
SCAD=openscad
SHELL=/bin/sh
# julia args
ARGS=
# source directories
JULIASRC=src
SCADSRC=scad
# export destination directory
DESTDIR=build
# optimized openscad parameter set json
PARAMSFILE=$(DESTDIR)/data.json
# extra openscad export arguments
SCADFLAGS=
# openscad theme for previews
COLORSCHEME=Starnight

# default target "flute"
.PHONY: flute
flute: previews models

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
	@echo -e " * Optimizing flute parameters: "$@
	@$(JULIA) $(JULIASRC)/main.jl $@

# 3mf scad file dependencies
include $(wildcard $(DESTDIR)/*.mk)
# compile scad to 3mf
$(DESTDIR)/%.3mf: $(SCADSRC)/%.scad $(PARAMSFILE)
	@mkdir -pv $(DESTDIR)
	@echo -e " * Exporting 3D model: "$@
	@$(SCAD) $< -q \
		-p $(PARAMSFILE) -P $(notdir $(@:.3mf=.data)) \
		-d $@.mk -m $(MAKE) \
		-o $@ $(subst $$,\$$,$(value SCADFLAGS))
	@echo -e " * Export Complete: "$@

# compile scad to preview png
$(DESTDIR)/%.png: $(SCADSRC)/%.scad $(PARAMSFILE)
	@mkdir -pv $(DESTDIR)
	@echo -e " * Rendering preview: "$@
	@$(SCAD) $< -q \
		-p $(PARAMSFILE) -P $(notdir $(@:.png=.data)) \
		-d $@.mk -m $(MAKE) \
		--colorscheme=$(COLORSCHEME) \
		--imgsize=960,1080 \
		-o $@ $(subst $$,\$$,$(value SCADFLAGS))
	@echo -e " * Preview Complete: "$@

.PHONY: workshop
workshop:
	@docker build . -t workshop

# clean build
.PHONY: clean
clean:
	@rm $(DESTDIR)/head*.mk $(DESTDIR)/body*.mk $(DESTDIR)/foot*.mk -fv

.PHONY: julia
julia:
	@$(JULIA) $(ARGS)
