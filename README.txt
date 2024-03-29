## Parametric Flute Modeling Tool
### Author: Arizona Hanson
### License: MIT

A parametric flute modeling tool
** NOTE *** requires 4 AS568-019 o-rings ** NOTE **

install make, julia 1.6, openscad
then run `make`

Exporting the three model files can take several minutes each. If you have multiple CPU cores,
you can speed up the build by running in parallel with the `-j` flag for make: `make -j3`

* better to use a tagged release
* branch `master` should be tested
* branch `develop` is likely untested
* any other branch is unstable

Environment variables determine the parameters of the flute, and default to a flute in
D major if not specified otherwise.

The `optimize` target will generate a 'parameters.json' file at path DESTDIR, containing flute parameters.
Deleting or moving this file will cause it to be regenerated. If files already exist at
path DESTDIR, they will only be overwritten if older than the dependencies.

Diameter and padding constraints are per hole. Padding refers to distance to previous hole,
or to the embouchure, measured from the centers. The FLUTE_MAX_PADDING may use
the value `Inf` to represent infinity (for no maximum).  Holes are referenced in order of
descending pitch, left to right as if holding the instrument.  The FLUTE_SCALE variable ends with the
lowest frequency of the flute, which is played with all holes covered.

environment variables (lists ordered head->foot, measurements in mm)
-----------------------------------------------------------------------------------
| variable            | default                | description                      |
-----------------------------------------------------------------------------------
| FLUTE_SCALE         | C♯5 B4 A4 G4 F♯4 E4 D4 | tones in flute scale # ♯ b ♭     |
| FLUTE_TUNING        | 440.0                  | tuning of A4 in Hz               |
| FLUTE_MAX_DIAMETERS | 9 10 9 9 10 9          | maximum hole diameters           |
| FLUTE_MAX_PADDING   | Inf 35 30 Inf 35 30    | maximum hole left-footward       |
| FLUTE_BREAK         | 3                      | number of holes on body          |
| DESTDIR             | build                  | directory to output files        |
| SCADFLAGS           |                        | extra openscad arguments         |
| TRACE               | true                   | show tracing of merit function   |
| FILE_TYPE           | 3mf                    | model format (3mf, stl, amf)     |
-----------------------------------------------------------------------------------

openscad variables (supply via SCADFLAGS)
-----------------------------------------------------------------------------
| variable         | default | description                                  |
-----------------------------------------------------------------------------
| LAYER_HEIGHT     | 0.162   | layer height in mm                           |
| SHRINK_FACTOR    | 0.015   | expected part shrinkage (for compensation)   |
-----------------------------------------------------------------------------

make targets
-------------------------------------------
| target   | description                  |
-------------------------------------------
| gcode    | generate gcode (default)     |
| models   | generate models              |
| previews | generate png previews        |
| optimize | generate parameters file     |
| clean    | delete temporary files       |
-------------------------------------------

Julia code uses utf8 math symbols that require font coverage:

𝑓   frequency, Hz
ϑ   temperature, °C
ℓ   length (distance) from embouchure, mm
𝜆   acoustic half-wavelength, mm
ℎ   hole height (depth), mm
⌀   inner bore diameter, mm
𝑑   hole diameter, mm

