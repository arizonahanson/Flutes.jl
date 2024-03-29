# flute constraints
ENVFILE=constraints
FILETYPE=stl
export
# program binaries
JULIA=docker run -it --env-file $(ENVFILE) --rm \
			-v "$(PWD)":/Flutes -w /Flutes workshop:latest julia
SCAD=openscad
SLIC3R=prusa-slicer
SHELL=/bin/sh
# julia args
ARGS=
# source directories
JULIASRC=src
SCADSRC=scad
# export destination directory
DESTDIR=build
# optimized openscad parameter set json
PARAMSFILE=$(DESTDIR)/parameters.json
SLICECONF=config.ini
# extra openscad export arguments
SCADFLAGS=--export-format=binstl
# openscad theme for previews
COLORSCHEME=Starnight

# scad dependency makefiles
include $(wildcard $(DESTDIR)/*.mk)

.DEFAULT_GOAL := gcode

# generate optimized parameters file (alias)
.PHONY: optimize
optimize: $(PARAMSFILE)

# generate image previews
.PHONY: previews
previews: $(DESTDIR)/head.png $(DESTDIR)/body.png $(DESTDIR)/foot.png

# generate 3D models (slow)
.PHONY: models
models: $(DESTDIR)/head.$(FILETYPE) $(DESTDIR)/body.$(FILETYPE) $(DESTDIR)/foot.$(FILETYPE)

.PHONE: gcode
gcode: $(DESTDIR)/head.gcode $(DESTDIR)/body.gcode $(DESTDIR)/foot.gcode $(DESTDIR)/calicat.gcode

# run optimization to generate parameters
$(PARAMSFILE): $(JULIASRC)/*.jl $(JULIASRC)/lib/*.jl
	@mkdir -pv $(dir $@)
	@echo " + Compiling flute optimization algorithm..."
	@$(JULIA) $(JULIASRC)/main.jl $@

# compile scad files
$(DESTDIR)/%.$(FILETYPE): $(SCADSRC)/%.scad $(PARAMSFILE)
	@mkdir -pv $(DESTDIR)
	@echo " + Modeling solid geometry: "$*
	@$(SCAD) $< -q \
		-p $(PARAMSFILE) -P $(notdir $(@:.$(FILETYPE)=.data)) \
		-d $@.mk -m $(MAKE) \
		-o $@ $(subst $$,\$$,$(value SCADFLAGS))
	@echo " - Model complete: "$@

$(DESTDIR)/calicat.gcode: test/calicat.$(FILETYPE) $(SLICECONF) $(PARAMSFILE)
	@echo " + Slicing solid model: "$<
	@$(SLIC3R) -g \
		--load $(SLICECONF) \
		-o $@ $< >/dev/null
	@echo " - Slicing complete: "$@

$(DESTDIR)/%.gcode: $(DESTDIR)/%.$(FILETYPE) $(SLICECONF)
	@echo " + Slicing solid model: "$<
	@$(SLIC3R) -g \
		--load $(SLICECONF) \
		-o $@ $< >/dev/null
	@echo " - Slicing complete: "$@

# compile scad to preview png
$(DESTDIR)/%.png: $(SCADSRC)/%.scad $(PARAMSFILE)
	@mkdir -pv $(DESTDIR)
	@echo " + Rendering geometry preview: "$*
	@$(SCAD) $< -q \
		-p $(PARAMSFILE) -P $(notdir $(@:.png=.data)) \
		-d $@.mk -m $(MAKE) \
		--colorscheme=$(COLORSCHEME) \
		--imgsize=960,1080 \
		-o $@ $(subst $$,\$$,$(value SCADFLAGS))
	@echo " - Render complete: "$@

# build julia image with packages installed
.PHONY: workshop
workshop:
	@docker build . -t workshop

# run julia image
.PHONY: julia
julia:
	@$(JULIA) $(ARGS)

# clean-up generated files
.PHONY: clean
clean:
	@rm $(DESTDIR)/*.png -fv
	@rm $(DESTDIR)/*.tmp -fv
	@rm $(DESTDIR)/*.mk -fv
