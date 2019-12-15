using Flutes
using Test

@test round(Flutes.soundspeed(0.0); sigdigits=4) == 331.3

@test round(Flutes.wavelength(261.625565, 25.0); sigdigits=4) == 1.323
