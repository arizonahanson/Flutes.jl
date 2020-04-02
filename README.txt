## Parametric Flute Modeling Tool
### Author: Isaac W Hanson
### License: MIT

A parametric flute modeling tool
**requires 4 AS568-019 o-rings**

install make, julia, openscad
then run `make all`

environment variables (lists ordered foot->head, measurements in mm)
----------------------------------------------------------------------------------
| variable            | default               | description                      |
----------------------------------------------------------------------------------
| FLUTE_SCALE         | D4 E4 F4 G4 A4 B♭4 C5 | notes in flute scale # ♯ b ♭     |
| FLUTE_BREAK         | 3                     | number of holes on foot          |
| FLUTE_MIN_DIAMETERS | 2 2 2 2 2 2           | minimum hole diameters           |
| FLUTE_MAX_DIAMETERS | 9 9 9 9 9 9           | maximum hole diameters           |
| FLUTE_MIN_PADDING   | 18 18 18 44 18 18     | minimum hole spacing to prev/end |
| FLUTE_MAX_PADDING   | Inf 40 35 Inf 40 35   | maximum hole spacing to prev/end |
| PREFIX              | build                 | directory to output stl files    |
| SFLAGS              |                       | extra openscad arguments         |
----------------------------------------------------------------------------------

openscad variables
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
| head   | generate headjoint stl       |
| body   | generate body stl            |
| foot   | generate footjoint stl       |
| clean  | delete head, body & foot stl |
-----------------------------------------

example
-------
make all PREFIX='cmajr' FLUTE_SCALE='C4 D4 E4 F4 G4 A4 B4'
-------
make all PREFIX='draft' SFLAGS='-DLAYER_HEIGHT=0.2'
