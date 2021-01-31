# flute constraints
ENV_FILE=constraints
export
# program binaries
JULIA=docker run -it --env-file $(ENV_FILE) --rm \
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
PARAMSFILE=$(DESTDIR)/parameters.json
# extra openscad export arguments
SCADFLAGS=
# openscad theme for previews
COLORSCHEME=Starnight

# generate 3D models (slow)
.PHONY: flute
flute: $(DESTDIR)/head.3mf $(DESTDIR)/body.3mf $(DESTDIR)/foot.3mf

# generate image previews
.PHONY: previews
previews: $(DESTDIR)/head.png $(DESTDIR)/body.png $(DESTDIR)/foot.png

.PHONY: head
head: $(DESTDIR)/head.3mf

.PHONY: body
body: $(DESTDIR)/body.3mf

.PHONY: foot
foot: $(DESTDIR)/foot.3mf

# generate optimized parameters file (alias)
.PHONY: optimize
optimize: $(PARAMSFILE)

# run optimization to generate parameters
$(PARAMSFILE): $(JULIASRC)/*.jl $(JULIASRC)/lib/*.jl
	@mkdir -pv $(dir $@)
	@echo " * Compiling flute optimizer"
	@$(JULIA) $(JULIASRC)/main.jl $@

# 3mf scad dependency makefiles
include $(wildcard $(DESTDIR)/*.mk)
# compile scad to 3mf
$(DESTDIR)/%.3mf: $(SCADSRC)/%.scad $(PARAMSFILE)
	@mkdir -pv $(DESTDIR)
	@echo " * Exporting 3D model: "$@
	@$(SCAD) $< -q \
		-p $(PARAMSFILE) -P $(notdir $(@:.3mf=.data)) \
		-d $@.mk -m $(MAKE) \
		-o $@ $(subst $$,\$$,$(value SCADFLAGS))
	@echo " * Export Complete: "$@

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

