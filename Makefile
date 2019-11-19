SRCDIR=src
OUTDIR=build
SRCFILE=flute.scad
OUTFILE=flute.stl
FLAGS=-Dfs=0.125 -Dfa=0.01

# build model
build: $(OUTDIR)/$(OUTFILE)

# compile scad file to stl
$(OUTDIR)/%.stl: $(SRCDIR)/%.scad $(SRCDIR)/**/*.scad Makefile
	mkdir -p $(OUTDIR)
	openscad $(FLAGS) -o $@ $<

# render model
start:
	@echo 'Starting openscad...'
	@openscad $(SRCDIR)/$(SRCFILE) >&2 2>/dev/null &

# delete build
clean:
	rm -rf $(OUTDIR)
