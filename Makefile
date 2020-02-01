
TEMPLATES=src/templates

default: all

.PHONY: all
all: headjoint

.PHONY: headjoint
headjoint: headjoint.stl

%.scad: $(TEMPLATES)/%.jl.scad $(TEMPLATES)/%.json
	@echo "making" $@
	@julia src/make.jl $@ $^

%.stl: %.scad
	@echo "making" $@
	openscad $< -o $@
