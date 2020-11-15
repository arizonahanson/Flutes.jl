export mapflute

"""
 𝒍 = mapflute(𝒇, 𝒅)

Calculate locations of toneholes, and length of flute
 for frequencies 𝒇 (Hz, descending pitch) and hole diameters 𝒅 (mm, same order)
 in mm measured from embouchure hole
"""
function mapflute(𝒇, 𝒅)
  # TODO: assumes standard temperature ϑ, bore diameter ⌀, wall thickness ℎ
  # hole positions
  𝒍 = []
  # number of holes
  ħ = length(𝒇)-1
  # accumulate closed-hole correction
  𝛥ℓᵥ = 0.0
  for h in 1:ħ
    𝑓 = 𝒇[h]    # opened hole frequency
    𝑓ₜ = 𝒇[h+1] # closed hole frequency
    𝑑ₕ = 𝒅[h]   # hole diameter
    ℓₕ = toneholelength(𝑓, 𝑓ₜ, 𝑑ₕ; 𝛥ℓᵥ=𝛥ℓᵥ) # calculate hole position
    𝒍 = [𝒍; ℓₕ] # append to result list
    # closed hole correction effect on remaining holes
    𝛥ℓᵥ += closedholecorrection(𝑓, 𝑓ₜ, 𝑑ₕ; 𝛥ℓᵥ=𝛥ℓᵥ)
  end
  # append flute tube length to result
  ℓₜ = flutelength(𝒇[end]; 𝛥ℓᵥ=𝛥ℓᵥ)
  return [𝒍; ℓₜ]
end
