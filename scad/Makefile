
PREFIX=../build

.PHONY: all
all: head body foot

.PHONY: head
head: $(PREFIX)/head.stl

.PHONY: body
body: $(PREFIX)/body.stl

.PHONY: foot
foot: $(PREFIX)/foot.stl

# compile stl from scad
$(PREFIX)/%.stl: %.scad lib/*.scad
	@echo "exporting" $@
	@mkdir -p $(PREFIX)
	openscad $< -o $@ $(subst $$,\$$,$(value SFLAGS))

# delete stl files
.PHONY: clean
clean:
	@rm -fv $(PREFIX)/head.stl
	@rm -fv $(PREFIX)/body.stl
	@rm -fv $(PREFIX)/foot.stl
