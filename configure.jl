#!/usr/bin/env julia
import Pkg; Pkg.activate(".")

using Flutes

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

scale = notes("FLUTE_SCALE")
mind = floats("FLUTE_MIN_DIAMETERS")
maxd = floats("FLUTE_MAX_DIAMETERS")
minp = floats("FLUTE_MIN_PADDING")
maxp = floats("FLUTE_MAX_PADDING")
brk = getint("FLUTE_BREAK")

flute = createflute(scale[1])
for h in 2:length(scale)
  addtonehole!(flute, scale[h]; 𝑑₋=mind[h-1], 𝑑₊=maxd[h-1], 𝑝₋=minp[h-1], 𝑝₊=maxp[h-1])
end
diameters = optimal(flute)

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
  # TODO tenon length, headjoint length
  brk_spc = max(0, (foot_holes[end][1] - body_holes[1][1] - 26)/2)
  lb = body_holes[1][1] + brk_spc + 26
  body_length = round(lb - 156; digits=2)
  foot_length = round(full_length - lb; digits=2)

  write(io, "-D'FOOT_HOLES=[")
  for hole in map(f->[f[1]-lb, f[2]], foot_holes)
    write(io, "["*join(map(s->string(round(s;digits=2)),hole),",")*"],")
  end
  write(io, "]' ")
  write(io, "-D'BODY_HOLES=[")
  for hole in map(b->[b[1]-156, b[2]], body_holes)
    write(io, "["*join(map(s->string(round(s;digits=2)),hole),",")*"],")
  end
  write(io, "]' ")

  write(io, "-DFOOT_LENGTH=$foot_length ")
  write(io, "-DBODY_LENGTH=$body_length")
  write(io, "\n")
end
