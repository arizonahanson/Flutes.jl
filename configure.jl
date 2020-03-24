#!/usr/bin/env julia
import Pkg; Pkg.activate(".")

function getenv(var)
  if !haskey(ENV, var)
    return ""
  end
  return ENV[var]
end

function mapenv(f, var)
  return map(f, split(getenv(var)))
end

using Flutes

function floats(var)
  return mapenv(x->parse(Float64,x), var)
end

function notes(var)
  return mapenv(note, var)
end

scale = notes("FLUTE_SCALE")
mind = floats("FLUTE_MIN_DIAMETERS")
maxd = floats("FLUTE_MAX_DIAMETERS")
minp = floats("FLUTE_MIN_PADDING")
maxp = floats("FLUTE_MAX_PADDING")

flute = createflute(scale[1])
for h in 2:length(scale)
  addtonehole!(flute, scale[h]; 𝑑₋=mind[h], 𝑑₊=maxd[h], 𝑝₋=minp[h], 𝑝₊=maxp[h])
end
println(optimal(flute))


# TODO: write SFLAGS to config
# BODY_HOLES
# BODY_LENGTH
# FOOT_HOLES
# FOOT_LENGTH
# SFLAGS='-DBODY_HOLES=[0.0, 0.0, 0.0] -DBODY_LENGTH=0.0'...
