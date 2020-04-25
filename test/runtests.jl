using Flutes
using Test

@test round(Flutes.soundspeed(0.0); sigdigits=6) == 331.316
@test round(Flutes.soundspeed(25.0); sigdigits=6) == 346.146
@test Flutes.tone("A4") == 440.0
@test Flutes.tone("A5"; A=442.0) == 884.0
@test Flutes.tone("C♯0") == 17.323914
@test Flutes.tone("C♭8") == 3951.06641
