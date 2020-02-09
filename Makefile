
TPL=tpl

.PHONY: all
all: headjoint

.PHONY: headjoint
headjoint: headjoint.stl

# render scad template
%.scad: $(TPL)/%.tpl.scad $(TPL)/%.tpl.json
	@echo "making" $@
	@julia render.jl $@ $^

# compile stl from scad
%.stl: %.scad
	@echo "making" $@
	openscad $< -o $@ -q

.PHONY: clean
clean:
	@git clean -fxd
