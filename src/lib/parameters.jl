
import JSON
export readvariable, mapvariable
export createscadparameters, setscadparameter!, writescadparameters
# create JSON parameter set for scad
function createscadparameters()
  return Dict(
              "fileFormatVersion" => "1",
              "parameterSets" => Dict(
                                      "foot.3mf.p" => Dict{String,String}(),
                                      "body.3mf.p" => Dict{String,String}()
                                     )
             )
end

# set a scad parameter
function setscadparameter!(parameters::Dict, setname::String, key::String, value)
  parameters["parameterSets"][setname][key] = JSON.json(value)
end

# write scad parameters to filename
function writescadparameters(parameters::Dict, filename::String)
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
