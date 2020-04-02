## Parametric Flute Modeling Tool
### Author: Isaac W Hanson
### License: MIT

A parametric flute modeling tool
** NOTE *** requires 4 AS568-019 o-rings ** NOTE **

install make, julia, openscad
then run `make all`

Environment variables determine the parameters of the flute, and default to a flute in
D major if not specified otherwise.

The `configure` step will generate a 'config' file containing flute parameters.
Deleting or moving this file will cause it to be regenerated. If the STL files already
exist at path PREFIX, they will only be overwritten if older than the dependencies.

Diameter and padding constraints are per hole. Padding refers to distance to previous hole,
or the end of the flute, measured from the centers. The FLUTE_MAX_PADDING may use
the value `Inf` to represent infinity (for no maximum).  Holes are referenced in order of
ascending pitch, starting at the foot.  The FLUTE_SCALE variable starts with the
lowest frequency of the flute, which is not associated with a tone hole.

environment variables (lists ordered foot->head, measurements in mm)
----------------------------------------------------------------------------------
| variable            | default               | description                      |
----------------------------------------------------------------------------------
| FLUTE_SCALE         | D4 E4 F4 G4 A4 B♭4 C5 | notes in flute scale # ♯ b ♭     |
| FLUTE_BREAK         | 3                     | number of holes on foot          |
| FLUTE_MIN_DIAMETERS | 2 2 2 2 2 2           | minimum hole diameters           |
| FLUTE_MAX_DIAMETERS | 9 9 9 9 9 9           | maximum hole diameters           |
| FLUTE_MIN_PADDING   | 18 18 18 44 18 18     | minimum hole padding-footward    |
| FLUTE_MAX_PADDING   | Inf 40 35 Inf 40 35   | maximum hole padding-footward    |
| PREFIX              | build                 | directory to output STL files    |
| SFLAGS              |                       | extra openscad arguments         |
----------------------------------------------------------------------------------

openscad variables (supply via SFLAGS)
----------------------------------------------------------------------------
| variable        | default | description                                  |
----------------------------------------------------------------------------
| LAYER_HEIGHT    | 0.162   | layer height in mm                           |
| NOZZLE_DIAMETER | 0.4     | nozzle diameter in mm                        |
----------------------------------------------------------------------------

openscad make targets
-----------------------------------------
| target | description                  |
-----------------------------------------
| all    | generate head, body & foot   |
| head   | generate headjoint STL       |
| body   | generate body STL            |
| foot   | generate footjoint STL       |
| clean  | delete generated files       |
-----------------------------------------

examples:

----make Dmaj flute; output to build/ folder----
make all

----make Cmaj flute in cmajr/ folder----
make all PREFIX='cmajr' FLUTE_SCALE='C4 D4 E4 F4 G4 A4 B4'

----Change layer height; output to draft/ folder----
make all PREFIX='draft' SFLAGS='-DLAYER_HEIGHT=0.2'
