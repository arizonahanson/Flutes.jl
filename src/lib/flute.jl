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

function createflute(𝒇, 𝒅₋, 𝒅₊, 𝒑₋, 𝒑₊)
  flute = FluteConstraint(𝒇[end], [])
  ħ = length(𝒇)-1
  for h in 1:ħ
    # constrain hole diameters & positions
    addtonehole!(flute, 𝒇[h]; 𝑑₋=𝒅₋[h], 𝑑₊=𝒅₊[h], 𝑝₋=𝒑₋[h], 𝑝₊=𝒑₊[h])
  end
  return flute
end

function mapflute(𝒇, 𝒅)
  𝒍 = []
  ħ = length(𝒇)-1
  𝛥ℓᵥ = 0.0
  for h in 1:ħ
    𝑓 = 𝒇[h]
    𝑓ₜ = 𝒇[h+1]
    𝑑ₕ = 𝒅[h]
    ℓₕ = toneholelength(𝑓; 𝑓ₜ=𝑓ₜ, 𝑑=𝑑ₕ, 𝛥ℓᵥ=𝛥ℓᵥ)
    𝒍 = [𝒍; ℓₕ]
    𝛥ℓᵥ += closedholecorrection(𝑓; 𝑓ₜ=𝑓ₜ, 𝑑=𝑑ₕ, 𝛥ℓᵥ=𝛥ℓᵥ)
  end
  ℓₜ = flutelength(𝒇[end]; 𝛥ℓᵥ=𝛥ℓᵥ)
  return [𝒍; ℓₜ]
end
