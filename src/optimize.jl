import Pkg
Pkg.activate(".")

using Flutes

function floats(var)
  return mapvariable(x->parse(Float64, x), var)
end

function tones(var)
  return mapvariable(tone, var)
end

# input env vars
scale = tones("FLUTE_SCALE")
mind = floats("FLUTE_MIN_DIAMETERS")
maxd = floats("FLUTE_MAX_DIAMETERS")
minp = floats("FLUTE_MIN_PADDING")
maxp = floats("FLUTE_MAX_PADDING")
brk = parse(Int, readvariable("FLUTE_BREAK"))

flute = createflute(scale[end])
for h in 1:length(scale)-1
  # constrain hole diameters & positions
  addtonehole!(flute, scale[h]; 𝑑₋=mind[h], 𝑑₊=maxd[h], 𝑝₋=minp[h], 𝑝₊=maxp[h])
end
# find best fit
# all the magic happens here
diameters = optimal(flute)
# end magic

# break holes by foot/body
foot_diameters = []
foot_positions = []
body_diameters = []
body_positions = []
𝛥ℓ = 0.0 # closed-hole correction
ℓₜ = flutelength(flute.𝑓)
for h in 1:length(diameters)
  𝑓ₕ = flute.holes[h].𝑓
  𝑑ₕ = diameters[h]
  ℓₕ = toneholelength(𝑓ₕ; 𝑑=𝑑ₕ) - 𝛥ℓ
  if h <= brk
    push!(body_diameters, 𝑑ₕ)
    push!(body_positions, ℓₕ)
  else
    push!(foot_diameters, 𝑑ₕ)
    push!(foot_positions, ℓₕ)
  end
  global 𝛥ℓ += closedholecorrection(𝑓ₕ; 𝑑=𝑑ₕ, ℓ𝑟=ℓₜ-ℓₕ)
end
flute_length = ℓₜ - 𝛥ℓ
tenon_length=26 # TODO: externalize constants
head_length=156

# place body/foot joint
spare = max((foot_positions[1] - body_positions[end] - tenon_length)/2, 0)
nofoot = body_positions[end] + spare + tenon_length
body_length = round(nofoot - head_length; digits=3)
foot_length = round(flute_length - nofoot; digits=3)

# export parameters to opencad json
params = createscadparameters()
bodyset = "body.3mf.params"
setscadparameter!(params, bodyset, "BODY_LENGTH", body_length)
setscadparameter!(params, bodyset, "BODY_DIAMETERS", map(bd->round(bd; digits=3), body_diameters))
setscadparameter!(params, bodyset, "BODY_POSITIONS", map(bp->round(bp-head_length; digits=3), body_positions))
footset = "foot.3mf.params"
setscadparameter!(params, footset, "FOOT_LENGTH", foot_length)
setscadparameter!(params, footset, "FOOT_DIAMETERS", map(fd->round(fd, digits=3), foot_diameters))
setscadparameter!(params, footset, "FOOT_POSITIONS", map(fp->round(fp-nofoot; digits=3), foot_positions))
writescadparameters(params, ARGS[1])

