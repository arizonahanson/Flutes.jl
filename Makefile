SRCDIR=src
OUTDIR=build
SRCFILE=flute.scad
OUTFILE=flute.stl
FLAGS=-Dfs=0.125 -Dfa=0.01

# build model
.PHONY: build
build: $(OUTDIR)/$(OUTFILE)

# compile stl from scad file
$(OUTDIR)/%.stl: $(SRCDIR)/%.scad $(SRCDIR)/**/*.scad Makefile
	mkdir -p $(OUTDIR)
	openscad $(FLAGS) -o $@ $<

# render model
.PHONY: start
start:
	openscad $(SRCDIR)/$(SRCFILE) >&2 2>/dev/null &

# delete build
.PHONY: clean
clean:
	rm -rf $(OUTDIR)
