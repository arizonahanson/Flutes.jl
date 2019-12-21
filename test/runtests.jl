using Flutes
using Test

@test Flutes.soundspeed(0.0) == 331300
@test Flutes.soundspeed(25.0) == 346100
@test round(Flutes.wavelength(261.6255653, 25.0); sigdigits=4) == 1323
