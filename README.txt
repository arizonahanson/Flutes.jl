## Parametric Flute Modeling Tool
### Author: Isaac W Hanson
### License: MIT

A work-in-progress parametric flute modeling tool

environment variables
------------------------------------------------------
| variable | default | description                   |
------------------------------------------------------
| PREFIX   | build   | directory to output stl files |
| ARGS     |         | extra openscad arguments      |
------------------------------------------------------

openscad variables
-----------------------------
| variable        | default |
-----------------------------
| LAYER_HEIGHT    | 0.162   |
| NOZZLE_DIAMETER | 0.4     |
-----------------------------

make targets
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
make all ARGS='-DLAYER_HEIGHT=0.32' PREFIX='draft'

