# build path
PREFIX=../build

# flute constraints
FLUTE_BREAK=3
FLUTE_SCALE=D4  E4 F4 G4  A4 B♭4 C5
FLUTE_MIN_DIAMETERS=2 2 2 2 2 2
FLUTE_MAX_DIAMETERS=9 9 9 9 9 9
FLUTE_MIN_PADDING=18 18 18 44 18 18
FLUTE_MAX_PADDING=Inf 40 35 Inf 40 35

include config
export

.PHONY: all
all: config
	$(MAKE) -C scad all

.PHONY: head
head: config
	$(MAKE) -C scad head

.PHONY: body
body: config
	$(MAKE) -C scad body

.PHONY: foot
foot: config
	$(MAKE) -C scad foot

config:
	julia ./configure.jl

# delete stl files
.PHONY: clean
clean:
	@rm -fv config
	$(MAKE) -C scad clean
