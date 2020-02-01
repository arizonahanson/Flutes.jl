
.PHONY: headjoint
headjoint: headjoint.stl

%.scad: src/templates/%.jl.scad src/templates/%.json
	julia src/make.jl $* $^

%.stl: %.scad
	openscad -o $@ $<
