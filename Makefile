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
CONFBUNDLE=Slic3r_config_bundle.ini
# extra openscad export arguments
SCADFLAGS=
# openscad theme for previews
COLORSCHEME=Starnight

.PHONE: gcode
gcode: $(DESTDIR)/head.gcode $(DESTDIR)/body.gcode $(DESTDIR)/foot.gcode

# generate 3D models (slow)
.PHONY: models
models: $(DESTDIR)/head.$(FTYPE) $(DESTDIR)/body.$(FTYPE) $(DESTDIR)/foot.$(FTYPE)

# generate image previews
.PHONY: previews
previews: $(DESTDIR)/head.png $(DESTDIR)/body.png $(DESTDIR)/foot.png

# generate optimized parameters file (alias)
.PHONY: optimize
optimize: $(PARAMSFILE)

.PHONY: head
head: $(DESTDIR)/head.$(FTYPE)

.PHONY: body
body: $(DESTDIR)/body.$(FTYPE)

.PHONY: foot
foot: $(DESTDIR)/foot.$(FTYPE)

# run optimization to generate parameters
$(PARAMSFILE): $(JULIASRC)/*.jl $(JULIASRC)/lib/*.jl
	@mkdir -pv $(dir $@)
	@echo " * Compiling flute optimizer"
	@$(JULIA) $(JULIASRC)/main.jl $@

# scad dependency makefiles
include $(wildcard $(DESTDIR)/*.mk)

# compile scad files
$(DESTDIR)/%.$(FTYPE): $(SCADSRC)/%.scad $(PARAMSFILE)
	@mkdir -pv $(DESTDIR)
	@echo " * Exporting 3D model: "$@
	@$(SCAD) $< -q \
		-p $(PARAMSFILE) -P $(notdir $(@:.$(FTYPE)=.data)) \
		-d $@.mk -m $(MAKE) \
		-o $@ $(subst $$,\$$,$(value SCADFLAGS))
	@echo " * Export Complete: "$@

$(DESTDIR)/%.gcode: $(DESTDIR)/%.$(FTYPE) $(CONFBUNDLE)
	@$(SLIC3R) --load $(CONFBUNDLE) -g -o $@ $<

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

