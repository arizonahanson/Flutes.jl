using Flutes
using Test

@test round(Flutes.soundspeed(0.0); sigdigits=4) == 331300

@test round(Flutes.wavelength(261.6255653, 25.0); sigdigits=4) == 1323
