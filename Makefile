SRCDIR=src
OUTDIR?=build
BASENAME?=flute
FLAGS?=-Dfs=0.125 -Dfa=0.01
EDITOR?=vi

# output stl model
.PHONY: build
build: $(OUTDIR)/$(BASENAME).stl

# output stl model matching scad file
$(OUTDIR)/%.stl: $(SRCDIR)/%.scad $(SRCDIR)/**/*.scad Makefile
	@mkdir -p $(OUTDIR)
	openscad $(FLAGS) -o $@ $<

# preview scad model
.PHONY: start
start:
	@openscad $(SRCDIR)/$(BASENAME).scad >&2 2>/dev/null &
	@$(EDITOR) $(SRCDIR)/$(BASENAME).scad

# delete output
.PHONY: clean
clean:
	@rm -rf $(OUTDIR) -v
