## Parametric Flute Modeling Tool
### Author: Isaac W Hanson
### License: MIT

A parametric flute modeling tool
** NOTE *** requires 4 AS568-019 o-rings ** NOTE **

install make, julia, openscad
then run `make`

Exporting the three 3mf files can take several minutes each. If you have multiple CPU cores,
you can speed up the build by running in parallel with the `-j` flag for make: `make -j3`

* better to use a tagged release
* branch `master` should be tested
* branch `develop` is likely untested
* any other branch is unstable

Environment variables determine the parameters of the flute, and default to a flute in
D major if not specified otherwise.

The `optimize` target will generate a 'data.json' file at path DESTDIR, containing flute parameters.
Deleting or moving this file will cause it to be regenerated. If files already exist at
path DESTDIR, they will only be overwritten if older than the dependencies.

Diameter and padding constraints are per hole. Padding refers to distance to previous hole,
or to the embouchure, measured from the centers. The FLUTE_MAX_PADDING may use
the value `Inf` to represent infinity (for no maximum).  Holes are referenced in order of
descending pitch, left to right as if holding the instrument.  The FLUTE_SCALE variable ends with the
lowest frequency of the flute, which is not associated with a tone hole.

environment variables (lists ordered head->foot, measurements in mm)
-----------------------------------------------------------------------------------
| variable            | default                | description                      |
-----------------------------------------------------------------------------------
| FLUTE_SCALE         | C♯5 B4 A4 G4 F♯4 E4 D4 | tones in flute scale # ♯ b ♭     |
| FLUTE_TUNING        | 442.0                  | tuning of A4 in Hz               |
| FLUTE_MIN_DIAMETERS | 3 3 3 3 3 3            | minimum hole diameters           |
| FLUTE_MAX_DIAMETERS | 9 9.5 9 9 10 9.5       | maximum hole diameters           |
| FLUTE_MIN_PADDING   | 163 18 18 44 18 18     | minimum hole left-padding        |
| FLUTE_MAX_PADDING   | Inf 40 35 Inf 35 35    | maximum hole left-footward       |
| FLUTE_BREAK         | 3                      | number of holes on body          |
| DESTDIR             | build                  | directory to output 3mf files    |
| SCADFLAGS           |                        | extra openscad arguments         |
-----------------------------------------------------------------------------------

openscad variables (supply via SCADFLAGS)
----------------------------------------------------------------------------
| variable        | default | description                                  |
----------------------------------------------------------------------------
| LAYER_HEIGHT    | 0.162   | layer height in mm                           |
| NOZZLE_DIAMETER | 0.4     | nozzle diameter in mm                        |
----------------------------------------------------------------------------

make targets
-------------------------------------------
| target   | description                  |
-------------------------------------------
| all      | generate all files (default) |
| previews | generate png previews        |
| models   | generate 3mf models          |
| head     | generate headjoint 3mf & png |
| body     | generate body 3mf & png      |
| foot     | generate foot 3mf & png      |
| optimize | generate parameters file     |
| clean    | delete temporary files       |
-------------------------------------------

examples:

----make Dmaj flute; output to build/ folder----
make all

----make Cmaj flute in cmajr/ folder----
make all DESTDIR='cmajr' FLUTE_SCALE='B4 A4 G4 F4 E4 D4 C4'

----Change layer height; output to draft/ folder----
make all DESTDIR='draft' SCADFLAGS='-DLAYER_HEIGHT=0.2'
