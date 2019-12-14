using Flutes
using Test

@test round(Flutes.soundspeed(0); sigdigits=4) == 331.3
