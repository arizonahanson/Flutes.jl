
SCAD_PATH=scad
PREFIX=build

.PHONY: all
all: head body foot

.PHONY: head
head: $(PREFIX)/head.stl

.PHONY: body
body: $(PREFIX)/body.stl

.PHONY: foot
foot: $(PREFIX)/foot.stl

# compile stl from scad
$(PREFIX)/%.stl: $(SCAD_PATH)/%.scad $(SCAD_PATH)/lib/*.scad
	@echo "making" $@"..."
	@mkdir -p $(PREFIX)
	openscad $< -q -o $@ $(subst $$,\$$,$(value SFLAGS))

# delete stl files
.PHONY: clean
clean:
	@rm -fv $(PREFIX)/head.stl
	@rm -fv $(PREFIX)/body.stl
	@rm -fv $(PREFIX)/foot.stl
