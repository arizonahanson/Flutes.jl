SRCDIR=src
OUTDIR=build
SRCFILE=flute.scad
OUTFILE=flute.stl
FLAGS=-Dfs=0.125

# build model
build: $(OUTDIR)/$(OUTFILE)

# compile scad file to stl
$(OUTDIR)/%.stl: $(SRCDIR)/%.scad $(SRCDIR)/**/*.scad Makefile
	mkdir -p $(OUTDIR)
	openscad $(FLAGS) -o $@ $<

# delete build
clean:
	rm -rf $(OUTDIR)
