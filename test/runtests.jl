using Flutes
using Test

@test Flutes.soundspeed(0.0) == 331300
@test Flutes.soundspeed(25.0) == 346100
