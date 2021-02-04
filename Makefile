# flute constraints
ENV_FILE=constraints
FTYPE=3mf
export
# program binaries
JULIA=docker run -it --env-file $(ENV_FILE) --rm \
			-v "$(PWD)":/Flutes.jl -w /Flutes.jl workshop:latest julia
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
SCADFLAGS=
# openscad theme for previews
COLORSCHEME=Starnight

# scad dependency makefiles
include $(wildcard $(DESTDIR)/*.mk)

default: gcode

# generate optimized parameters file (alias)
.PHONY: optimize
optimize: $(PARAMSFILE)

# generate image previews
.PHONY: previews
previews: $(DESTDIR)/head.png $(DESTDIR)/body.png $(DESTDIR)/foot.png

# generate 3D models (slow)
.PHONY: models
models: $(DESTDIR)/head.$(FTYPE) $(DESTDIR)/body.$(FTYPE) $(DESTDIR)/foot.$(FTYPE)

.PHONE: gcode
gcode: $(DESTDIR)/head.gcode $(DESTDIR)/body.gcode $(DESTDIR)/foot.gcode

# run optimization to generate parameters
$(PARAMSFILE): $(JULIASRC)/*.jl $(JULIASRC)/lib/*.jl
	@mkdir -pv $(dir $@)
	@echo " * Compiling flute optimizer"
	@$(JULIA) $(JULIASRC)/main.jl $@

# compile scad files
$(DESTDIR)/%.$(FTYPE): $(SCADSRC)/%.scad $(PARAMSFILE)
	@mkdir -pv $(DESTDIR)
	@echo " * Exporting 3D model: "$@
	@$(SCAD) $< -q \
		-p $(PARAMSFILE) -P $(notdir $(@:.$(FTYPE)=.data)) \
		-d $@.mk -m $(MAKE) \
		-o $@ $(subst $$,\$$,$(value SCADFLAGS))
	@echo " * Export Complete: "$@

$(DESTDIR)/%.gcode: $(DESTDIR)/%.$(FTYPE) $(SLICECONF)
	@echo " * Slicing gcode: "$@
	@$(SLIC3R) -g \
		--load $(SLICECONF) \
		-o $@ $< >/dev/null
	@echo " * Slicing Complete: "$@

# compile scad to preview png
$(DESTDIR)/%.png: $(SCADSRC)/%.scad $(PARAMSFILE)
	@mkdir -pv $(DESTDIR)
	@echo " * Rendering preview: "$@
	@$(SCAD) $< -q \
		-p $(PARAMSFILE) -P $(notdir $(@:.png=.data)) \
		-d $@.mk -m $(MAKE) \
		--colorscheme=$(COLORSCHEME) \
		--imgsize=960,1080 \
		-o $@ $(subst $$,\$$,$(value SCADFLAGS))
	@echo " * Render Complete: "$@

# build julia image with packages installed
.PHONY: workshop
workshop:
	@docker build . -t workshop

# run julia image
.PHONY: julia
julia:
	@$(JULIA) $(ARGS)

# clean-up .mk files
.PHONY: clean
clean:
	@rm $(DESTDIR)/*.mk -fv
	@rm $(DESTDIR)/*.png -fv

