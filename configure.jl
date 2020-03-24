#!/usr/bin/env julia

# activate flute package
import Pkg; Pkg.activate(".")
using Flutes

function getvar(n)
  if !haskey(ENV, n)
    return ""
  end
  return ENV[n]
end

function mapvars(f, n)
  if !haskey(ENV, n)
    return []
  end
  return map(f, split(ENV[n]))
end

function mapfloat(n)
  return mapvars(x->parse(Float64,x), n)
end

function getscale()
  return mapvars(note, "FLUTE_SCALE")
end

function getmindiameters()
  return mapfloat("FLUTE_MIN_DIAMETERS")
end

function getmaxdiameters()
  return mapfloat("FLUTE_MAX_DIAMETERS")
end

function getminpadding()
  return mapfloat("FLUTE_MIN_PADDING")
end

function getmaxpadding()
  return mapfloat("FLUTE_MAX_PADDING")
end

scale = getscale()
println(scale)
open("config","w") do io
  write(io, "SFLAGS=-DNOZZLE_DIAMETER=0.4 "*getvar("SFLAGS")*"\n")
end
# TODO: write SFLAGS to config
## BODY_HOLES
## BODY_LENGTH
## FOOT_HOLES
## FOOT_LENGTH
#SFLAGS='-DBODY_HOLES=[0.0, 0.0, 0.0] -DBODY_LENGTH=0.0'...
