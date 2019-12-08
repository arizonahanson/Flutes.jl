## default build env
OUTDIR?=build
OUTFILES?=src/scad/Flute.stl
OUTFLAGS?=-Dfs=0.125 -Dfa=0.01

EDITOR?=vi
EDITFILE=src/scad/Flute.scad
DEPFILES=src/**/*.scad Makefile

# output stl model
.PHONY: build
build: $(OUTFILES)
	@mkdir -p $(OUTDIR)
	@cp -v $(OUTFILES) $(OUTDIR)

# output stl model matching scad file
%.stl: %.scad $(DEPFILES)
	openscad $(OUTFLAGS) -o $@ $<

# preview scad model
.PHONY: start
start:
	@openscad $(EDITFILE) >&2 2>/dev/null &
	@$(EDITOR) $(EDITFILE)

# delete output
.PHONY: clean
clean:
	@rm -fv $(OUTFILES)
	@rm -rfv $(OUTDIR)
