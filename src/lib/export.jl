import JSON
export readvariable, mapvariable, floats, tones
export createscadparameters, setscadparameter!, writescadparameters
using DataStructures

# create JSON parameter set for scad
function createscadparameters()
  return OrderedDict("fileFormatVersion" => "1", "parameterSets" => OrderedDict())
end

# set a scad parameter
function setscadparameter!(parameters::OrderedDict, setname::String, key::String, value)
  sets = parameters["parameterSets"]
  if !haskey(sets, setname)
    sets[setname] = OrderedDict{String,String}()
  end
  if typeof(value) == String
    sets[setname][key] = value
  else
    sets[setname][key] = JSON.json(value)
  end
end

# write scad parameters to filename
function writescadparameters(parameters::OrderedDict, filename::String)
  open(filename, "w") do io
    write(io, JSON.json(parameters, 2))
  end
end

# read an environment variable
function readvariable(name::String)
  if !haskey(ENV, name)
    return nothing
  end
  return ENV[name]
end

function mapvariable(fn::Function, name::String)
  if !haskey(ENV, name)
    return nothing
  end
  map(fn, split(readvariable(name)))
end

function floats(var)
  return mapvariable(x->parse(Float64, x), var)
end

function tones(var, A)
  return mapvariable(v->tone(v; A=A), var)
end
