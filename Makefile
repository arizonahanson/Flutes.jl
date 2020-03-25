
# build path
PREFIX=../build
# flute constraints
FLUTE_BREAK=3
FLUTE_SCALE=D4  F4 G4 A4  C5 D5 F5
FLUTE_MIN_DIAMETERS=2 2 2  2 2 2
FLUTE_MAX_DIAMETERS=10 10 10  10 10 10
FLUTE_MIN_PADDING=9 9 9  30 9 9
FLUTE_MAX_PADDING=Inf 30 30  Inf 30 30
include config
export

.PHONY: all
all: config
	$(MAKE) -C scad all

config:
	julia ./configure.jl

# delete stl files
.PHONY: clean
clean:
	@rm -fv config
	$(MAKE) -C scad clean
