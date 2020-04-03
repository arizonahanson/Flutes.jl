# build path
PREFIX=../build
# flute constraints
FLUTE_BREAK=3
FLUTE_SCALE=D4 E4 F♯4 G4 A4 B4 C♯5
FLUTE_MIN_DIAMETERS=2 2 2 2 2 2
FLUTE_MAX_DIAMETERS=9 9 9 9 9 9
FLUTE_MIN_PADDING=18 18 18 44 18 18
FLUTE_MAX_PADDING=Inf 40 35 Inf 40 35
export

.PHONY: flute.mk
flute.mk:
	@mkdir -p $(PREFIX)
	julia optimize.jl $(PREFIX)/flute.mk

.PHONY: clean
clean:
	@rm -fv $(PREFIX)/flute.mk
