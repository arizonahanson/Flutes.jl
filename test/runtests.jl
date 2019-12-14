using Flutes
using Test

@test round(Flutes.soundspeed(0.0); sigdigits=4) == 331.3
@test round(Flutes.wavelength(440.0, 25.0); sigdigits=4) == 0.7866
