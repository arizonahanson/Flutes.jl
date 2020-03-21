## Parametric Flute Modeling Tool
### Author: Isaac W Hanson
### License: MIT

A work-in-progress parametric flute modeling tool

environment variables
------------------------------------------------------
| variable | default | description                   |
------------------------------------------------------
| PREFIX   | build   | directory to output stl files |
| SFLAGS   |         | extra openscad arguments      |
------------------------------------------------------

openscad variables
----------------------------------------------------------------------
| variable        | default | description                            |
----------------------------------------------------------------------
| LAYER_HEIGHT    | 0.162   | layer height                           |
| NOZZLE_DIAMETER | 0.4     | nozzle diameter                        |
| BODY_LENGTH     | 26      | body length                            |
| BODY_HOLES      | []      | vector of [position, diameter] vectors |
| FOOT_LENGTH     | 0       | foot length                            |
| FOOT_HOLES      | []      | vector of [position, diameter] vectors |
----------------------------------------------------------------------

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
make all SFLAGS='-DLAYER_HEIGHT=0.32' PREFIX='draft'

