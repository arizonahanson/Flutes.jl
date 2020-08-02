import Pkg
Pkg.activate(".")
Pkg.instantiate()

using Flutes
using Dates

# input env vars
tuning = parse(Float64, readvariable("FLUTE_TUNING"))
scale = tones("FLUTE_SCALE", tuning)
mind = floats("FLUTE_MIN_DIAMETERS")
maxd = floats("FLUTE_MAX_DIAMETERS")
minp = floats("FLUTE_MIN_PADDING")
maxp = floats("FLUTE_MAX_PADDING")
brk = parse(Int, readvariable("FLUTE_BREAK"))
trace = parse(Bool, readvariable("TRACE"))

# find best fit
# all the magic happens here
diameters = optimal(scale, mind, maxd, minp, maxp; trace=trace)
lengths = round.(mapflute(scale, diameters); digits=3)
# end magic

# display hole separations
with_origin = [0.0; lengths]
print("|")
for h in 1:length(lengths)
  print(" ∘ ", round(with_origin[h+1]-with_origin[h]; digits=2))
end
println(" |")

# break holes by foot/body
body_diameters = round.(diameters[1:brk]; digits=3)
body_positions = lengths[1:brk]
foot_diameters = round.(diameters[brk+1:end]; digits=3)
foot_positions = lengths[brk+1:end-1]
flute_length = lengths[end]
# place body/foot joint
tenon_length = 26
head_length = 154.6 # TODO lose the constant
spare = max((foot_positions[1] - body_positions[end] - tenon_length)/2, 0)
nofoot = body_positions[end] + spare + tenon_length
body_length = round(nofoot - head_length; digits=3)
foot_length = round(flute_length - nofoot; digits=3)

# export parameters to opencad props
params = createscadparameters()
headset = "head.data"
setscadparameter!(params, headset, "HeadLength", head_length)
setscadparameter!(params, headset, "TenonLength", tenon_length)
bodyset = "body.data"
setscadparameter!(params, bodyset, "BodyLength", body_length)
setscadparameter!(params, bodyset, "HoleDiameters", body_diameters)
setscadparameter!(params, bodyset, "HolePositions", map(bp->round(bp-head_length; digits=3), body_positions))
setscadparameter!(params, bodyset, "TenonLength", tenon_length)
setscadparameter!(params, bodyset, "MortiseLength", tenon_length)
footset = "foot.data"
setscadparameter!(params, footset, "FootLength", foot_length)
setscadparameter!(params, footset, "HoleDiameters", foot_diameters)
setscadparameter!(params, footset, "HolePositions", map(fp->round(fp-nofoot; digits=3), foot_positions))
setscadparameter!(params, footset, "MortiseLength", tenon_length)
extraset = "extra.data"
setscadparameter!(params, extraset, "CreationDate", now())
setscadparameter!(params, extraset, "Tuning", tuning)
setscadparameter!(params, extraset, "Scale", readvariable("FLUTE_SCALE"))
writescadparameters(params, ARGS[1])

