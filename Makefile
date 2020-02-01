
SCAD=src/scad

.PHONY: all
all: headjoint

.PHONY: headjoint
headjoint: headjoint.stl

# render jl.scad template
%.scad: $(SCAD)/%.jl.scad $(SCAD)/%.json
	@echo "making" $@
	@julia src/make.jl $@ $^

# compile stl from scad
%.stl: %.scad
	@echo "making" $@
	openscad $< -o $@ -q

.PHONY: clean
clean:
	@git clean -fxd
