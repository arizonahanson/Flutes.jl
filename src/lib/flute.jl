export FluteConstraint, ToneHoleConstraint
export createflute, addtonehole!, mapflute

struct FluteConstraint
  𝑓  # lowest frequency
  holes
end

struct ToneHoleConstraint
  𝑓  # hole frequency
  𝑑₋ # min diameter
  𝑑₊ # max diameter
  𝑝₋ # min separation
  𝑝₊ # max separation
end

function addtonehole!(flute::FluteConstraint, 𝑓; 𝑑₋=2.0, 𝑑₊=9.0, 𝑝₋=15.0, 𝑝₊=40.0)
  push!(flute.holes, ToneHoleConstraint(𝑓, 𝑑₋, 𝑑₊, 𝑝₋, 𝑝₊))
end

function createflute(𝑓)
  return FluteConstraint(𝑓, [])
end

function mapflute(flute::FluteConstraint, 𝒅)
  result = []
  𝒇 = map(h->h.𝑓, flute.holes); push!(𝒇, flute.𝑓)
  𝛥ℓᵥ = 0.0 # closed-hole correction
  for h in 1:length(flute.holes)
    𝑓 = 𝒇[h] # open hole frequency
    𝑓ₜ = 𝒇[h+1] # closed hole frequency
    𝑑ₕ = 𝒅[h] # hole diameter
    ℓₕ = toneholelength(𝑓; 𝑓ₜ=𝑓ₜ, 𝑑=𝑑ₕ, 𝛥ℓᵥ=𝛥ℓᵥ) # resulting location
    push!(result, ℓₕ)
    𝛥ℓᵥ += closedholecorrection(𝑓; 𝑓ₜ=𝑓ₜ, 𝑑=𝑑ₕ, 𝛥ℓᵥ=𝛥ℓᵥ)
  end
  ℓₜ = flutelength(flute.𝑓; 𝛥ℓᵥ=𝛥ℓᵥ)
  push!(result, ℓₜ)
  return result
end
