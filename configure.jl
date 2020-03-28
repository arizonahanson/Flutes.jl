#!/usr/bin/env julia
import Pkg; Pkg.activate(".")

using Flutes

# TODO: externalize this?
function getenv(var)
  if !haskey(ENV, var)
    return ""
  end
  return ENV[var]
end

function getint(var)
  if !haskey(ENV, var)
    return 0
  end
  return parse(Int, getenv(var))
end

function mapenv(f, var)
  return map(f, split(getenv(var)))
end

function floats(var)
  return mapenv(x->parse(Float64, x), var)
end

function notes(var)
  return mapenv(note, var)
end

# input env vars
scale = notes("FLUTE_SCALE")
mind = floats("FLUTE_MIN_DIAMETERS")
maxd = floats("FLUTE_MAX_DIAMETERS")
minp = floats("FLUTE_MIN_PADDING")
maxp = floats("FLUTE_MAX_PADDING")
brk = getint("FLUTE_BREAK")

# all the magic happens here
flute = createflute(scale[1])
for h in 2:length(scale)
  # constrain hole diameters & positions
  addtonehole!(flute, scale[h]; 𝑑₋=mind[h-1], 𝑑₊=maxd[h-1], 𝑝₋=minp[h-1], 𝑝₊=maxp[h-1])
end
# find best fit
diameters = optimal(flute)
# end magic

# TODO: externalize constants
tenon_length=26
head_length=156
# TODO: uncomplicate communicating results downstream...
open("config", "w") do io
  foot_holes = []
  body_holes = []
  write(io, "SFLAGS=")
  full_length=flutelength(flute.𝑓)
  for h in 1:length(diameters)
    𝑑ₕ = diameters[h]
    ℓₕ = toneholelength(flute.holes[h].𝑓; 𝑑=𝑑ₕ)
    pair = [ℓₕ, 𝑑ₕ]
    println(pair)
    if h > brk
      push!(body_holes, pair)
    else
      push!(foot_holes, pair)
    end
  end
  # calculate breakpoint
  spare = max((foot_holes[end][1] - body_holes[1][1] - tenon_length)/2, 0)
  nofoot = body_holes[1][1] + spare + tenon_length
  body_length = round(nofoot - head_length; digits=2)
  foot_length = round(full_length - nofoot; digits=2)

  write(io, "-D'FOOT_HOLES=[")
  for hole in map(f->[f[1]-nofoot, f[2]], foot_holes)
    write(io, "["*join(map(s->string(round(s;digits=2)),hole),",")*"],")
  end
  write(io, "]' ")
  write(io, "-D'BODY_HOLES=[")
  for hole in map(b->[b[1]-head_length, b[2]], body_holes)
    write(io, "["*join(map(s->string(round(s;digits=2)),hole),",")*"],")
  end
  write(io, "]' ")

  write(io, "-DFOOT_LENGTH=$foot_length ")
  write(io, "-DBODY_LENGTH=$body_length")
  write(io, "\n")
end
