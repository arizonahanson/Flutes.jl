export FluteConstraint, mapflute

struct FluteConstraint
  𝒇  # frequencies
  𝒅₋ # min diameters
  𝒅₊ # max diameters
  𝒑₋ # min separation
  𝒑₊ # max separation
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
