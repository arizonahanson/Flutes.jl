## Parametric Flute Modeling Tool
### Author: Isaac W Hanson
### License: MIT

A work-in-progress parametric flute modeling tool

environment variables
----------------------------------------------------------------------------------
| variable            | default               | description                      |
----------------------------------------------------------------------------------
| FLUTE_SCALE         | D4 E4 F4 G4 A4 B♭4 C5 | notes in flute scale # ♯ b ♭     |
| FLUTE_BREAK         | 3                     | number of holes on foot          |
| FLUTE_MIN_DIAMETERS | 2 2 2 2 2 2           | minimum hole diameters           |
| FLUTE_MAX_DIAMETERS | 9 9 9 9 9 9           | maximum hole diameters           |
| FLUTE_MIN_PADDING   | 18 18 18 30 18 18     | minimum hole spacing to prev/end |
| FLUTE_MAX_PADDING   | Inf 40 35 Inf 40 35   | maximum hole spacing to prev/end |
| SFLAGS              |                       | extra openscad arguments         |
| PREFIX              | build                 | directory to output stl files    |
----------------------------------------------------------------------------------

openscad variables
----------------------------------------------------------------------------
| variable        | default | description                                  |
----------------------------------------------------------------------------
| LAYER_HEIGHT    | 0.162   | layer height in mm                           |
| NOZZLE_DIAMETER | 0.4     | nozzle diameter in mm                        |
| BODY_HOLES      | []      | vector of [position, diameter] vectors in mm |
| FOOT_HOLES      | []      | vector of [position, diameter] vectors in mm |
| BODY_LENGTH     | 0       | body length in mm                            |
| FOOT_LENGTH     | 0       | foot length in mm                            |
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

