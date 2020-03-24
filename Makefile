
# build path
PREFIX=../build
# flute constraints
FLUTE_SCALE=C4 D4 E4 F4  G4 A4 B4
FLUTE_MIN_DIAMETERS=2 2 2 2  2 2 2
FLUTE_MAX_DIAMETERS=8 9 9 9  9 9 9
FLUTE_MIN_PADDING=10 10 10 10  10 10 10
FLUTE_MAX_PADDING=Inf 30 30 30  Inf 30 30
include config
export

.PHONY: all
all:
	$(MAKE) -C scad all

config:
	julia ./configure.jl

# delete stl files
.PHONY: clean
clean:
	@rm -fv config
	$(MAKE) -C scad clean
