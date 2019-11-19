INFILE=src/flute.scad
DEPFILES=src/*.scad
OUTFILE=flute.stl
RESOLUTION=0.125

# build model
build: $(OUTFILE)
$(OUTFILE): $(DEPFILES) Makefile
	openscad $(INFILE) -o $(OUTFILE) -Dfs=$(RESOLUTION)

# delete build
clean:
	rm -f $(OUTFILE)
