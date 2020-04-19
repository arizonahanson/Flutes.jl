using Flutes
using Test

@test round(Flutes.soundspeed(0.0); sigdigits=6) == 331316.0
@test round(Flutes.soundspeed(25.0); sigdigits=6) == 346146.0
@test Flutes.tone("A4") == 440.0
@test Flutes.tone("C♯0") == 17.323914
@test Flutes.tone("C♭8") == 3951.06641
