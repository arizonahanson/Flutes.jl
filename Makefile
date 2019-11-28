SRCDIR=src
OUTDIR=build
BASENAME=flute
FLAGS=-Dfs=0.125 -Dfa=0.01

SRCFILE=$(BASENAME).scad
OUTFILE=$(BASENAME).stl

# output stl model
.PHONY: build
build: $(OUTDIR)/$(OUTFILE)

# output stl model matching scad file
$(OUTDIR)/%.stl: $(SRCDIR)/%.scad $(SRCDIR)/**/*.scad Makefile
	mkdir -p $(OUTDIR)
	openscad $(FLAGS) -o $@ $<

# preview scad model
.PHONY: start
start:
	openscad $(SRCDIR)/$(SRCFILE) >&2 2>/dev/null &

# delete output
.PHONY: clean
clean:
	rm -rf $(OUTDIR)
