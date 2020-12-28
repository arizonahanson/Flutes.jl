import Pkg
Pkg.activate(".")
Pkg.instantiate()

using Flutes
using Dates

# input env vars
tuning = parse(Float64, readvariable("FLUTE_TUNING"))
scale = tones("FLUTE_SCALE", tuning)
maxd = floats("FLUTE_MAX_DIAMETERS")
maxp = floats("FLUTE_MAX_PADDING")
rots = floats("FLUTE_HOLE_ROTATIONS")
brk = parse(Int, readvariable("FLUTE_BREAK"))
head_length = parse(Float64, readvariable("FLUTE_HEAD_LENGTH"))
tenon_length = parse(Float64, readvariable("FLUTE_TENON_LENGTH"))
trace = parse(Bool, readvariable("TRACE"))

# minimum diameters = 1mm
mind = fill(1, length(maxd))
# calculate minimum padding between holes
minp = []
for h in 1:length(maxd)
  mp = 0
  if h == 1
    # first hole must be on body, not the headjoint
    mp = head_length+maxd[h]
  elseif h == brk+1
    # make room for the tenon/mortise at the break point
    mp = maxd[brk]+tenon_length+maxd[h]
  else
    # minimum hole spacing (sum of max diameters)
    mp = maxd[h-1]+maxd[h]
  end
  append!(minp, mp)
end

# find best fit
# all the magic happens here
println("Optimizing flute parameters: ", ARGS[1])
diameters = optimal(scale, mind, maxd, minp, maxp; trace=trace)
lengths = round.(mapflute(scale, diameters); digits=4)
# end magic

# display hole separations
with_origin = [0.0; lengths]
print("|")
for h in 1:length(lengths)
  print(" ∘ ", round(with_origin[h+1]-with_origin[h]; digits=1))
end
println(" |")

# break holes by foot/body
body_diameters = round.(diameters[1:brk]; digits=4)
body_positions = lengths[1:brk]
body_rotations = rots[1:brk]

foot_diameters = round.(diameters[brk+1:end]; digits=4)
foot_positions = lengths[brk+1:end-1]
foot_rotations = rots[brk+1:end]

# place body/foot joint
spare = max((foot_positions[1] - body_positions[end] - tenon_length)/2, 0)
nofoot = body_positions[end] + spare + tenon_length

flute_length = lengths[end]
body_length = round(nofoot - head_length; digits=4)
foot_length = round(flute_length - nofoot; digits=4)

# export parameters to opencad props
params = createscadparameters()
headset = "head.data"
setscadparameter!(params, headset, "HeadLength", head_length)
setscadparameter!(params, headset, "TenonLength", tenon_length)
bodyset = "body.data"
setscadparameter!(params, bodyset, "BodyLength", body_length)
setscadparameter!(params, bodyset, "HoleDiameters", body_diameters)
setscadparameter!(params, bodyset, "HolePositions", map(bp->round(bp-head_length; digits=4), body_positions))
setscadparameter!(params, bodyset, "HoleRotations", body_rotations)
setscadparameter!(params, bodyset, "TenonLength", tenon_length)
setscadparameter!(params, bodyset, "MortiseLength", tenon_length)
footset = "foot.data"
setscadparameter!(params, footset, "FootLength", foot_length)
setscadparameter!(params, footset, "HoleDiameters", foot_diameters)
setscadparameter!(params, footset, "HolePositions", map(fp->round(fp-nofoot; digits=4), foot_positions))
setscadparameter!(params, footset, "HoleRotations", foot_rotations)
setscadparameter!(params, footset, "MortiseLength", tenon_length)
extraset = "extra.data"
setscadparameter!(params, extraset, "CreationDate", now())
setscadparameter!(params, extraset, "Tuning", tuning)
setscadparameter!(params, extraset, "Scale", readvariable("FLUTE_SCALE"))
writescadparameters(params, ARGS[1])

