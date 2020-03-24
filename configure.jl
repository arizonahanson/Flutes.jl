#!/usr/bin/env julia

# activate flute package
import Pkg; Pkg.activate(".")
using Flutes

function getenv(var)
  if !haskey(ENV, var)
    return ""
  end
  return ENV[var]
end

function mapenv(f, var)
  return map(f, split(getenv(var)))
end

function floats(var)
  return mapenv(x->parse(Float64,x), var)
end

function notes(var)
  return mapenv(note, var)
end

# TODO: write SFLAGS to config
## BODY_HOLES
## BODY_LENGTH
## FOOT_HOLES
## FOOT_LENGTH
#SFLAGS='-DBODY_HOLES=[0.0, 0.0, 0.0] -DBODY_LENGTH=0.0'...
