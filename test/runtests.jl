using Flutes
using Test

@test Flutes.soundspeed(0.0) == 331316.0
@test Flutes.soundspeed(25.0) == 346146.0
@test Flutes.note("A4") == 440.0
@test Flutes.note("C♯0") == 17.323914
@test Flutes.note("C♭8") == 3951.06641
