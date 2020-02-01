
TEMPLATES=src/templates

.PHONY: all
all: headjoint

.PHONY: headjoint
headjoint: headjoint.stl

# render jl.scad template
%.scad: $(TEMPLATES)/%.jl.scad $(TEMPLATES)/%.json
	@echo "making" $@
	@julia src/make.jl $@ $^

# compile stl from scad
%.stl: %.scad
	@echo "making" $@
	openscad $< -o $@ -q
