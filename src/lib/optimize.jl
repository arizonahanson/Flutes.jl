export optimal
using Optim
using Statistics

# sum of absolute differences (element-wise)
function Δ⃯(𝒄₁, 𝒄₂)
  return sum(abs.(𝒄₁- 𝒄₂))
end

# sum of distances outside bounding box (element-wise)
function Δ͍(𝒄, 𝒄₋, 𝒄₊)
  return sum(max.(𝒄₋-𝒄, 0.0, 𝒄-𝒄₊))
end

# collection 𝒄 with last element dropped
function drop(𝒄)
  return 𝒄[1:end-1]
end

# fill collection with length of 𝒄 with average of 𝒄
function avg(𝒄)
  return fill(mean(𝒄), length(𝒄))
end

# map frequencies and diameters to locations, but drop the flute-length value
⇴ = drop ∘ mapflute
# push a value to front of vector, while dropping last value
⥆ = drop ∘ vcat

# generate error function with scoped constants
function mkerrfn(𝒇, 𝒅₊, 𝒑₋, 𝒑₊)
  𝒍⃯ = 𝒇⇴ 𝒅₊ # positions of holes with maximum allowed diameters
  function errfn(𝒅)
    # locations
    𝒍 = 𝒇⇴ 𝒅      # proposed diameters
    𝒍̲ = 𝒇⇴ avg(𝒅) # average of proposed
    𝒍⃮ = 0.0⥆ 𝒍    # shift proposed locations left (push 0.0)
    𝒍⃭ = 𝒍⃮+𝒑₋      # closest desired position to previous hole
    𝒍⃬ = 𝒍⃮+𝒑₊      # furthest desired position from previous hole
    # error terms
    𝑒̲ = Δ⃯(𝒍, 𝒍̲)       # sum of distances from average
    𝑒⃯ = Δ⃯(𝒍, 𝒍⃯)       # sum of distances from max positions
    𝑒͍ = Δ͍(𝒍, 𝒍⃭, 𝒍⃬)^2  # squared sum of distances outside desired from previous holes
    # sum and weigh error terms
    𝑒 = 𝑒̲ + 2𝑒⃯ + 3𝑒͍
    return 𝑒
  end
  return errfn
end

function optimal(𝒇, 𝒅₋, 𝒅₊, 𝒑₋, 𝒑₊; trace=false)
  # minimize error function
  errfn = mkerrfn(𝒇, 𝒅₊, 𝒑₋, 𝒑₊)
  # box-constrained, initial parameters (bad guess)
  𝒅₁ = [8.9, 8.8, 6.5, 8.9, 9.9, 5.5]
  # simulated annealing (round 1, fast cooldown)
  options = Optim.Options(iterations=Int(2e5), show_trace=trace, show_every=Int(1e4))
  𝒅₂ = Optim.minimizer(optimize(errfn, 𝒅₋, 𝒅₊, 𝒅₁, SAMIN(rt=0.50), options))
  # simulated annealing (round 2, slow cooldown)
  options = Optim.Options(iterations=Int(4e5), show_trace=trace, show_every=Int(2e4))
  result = optimize(errfn, 𝒅₋, 𝒅₊, 𝒅₂, SAMIN(rt=0.98), options)
  𝒅ₕ = Optim.minimizer(result)
  𝑒 = Optim.minimum(result)
  # proposed diameters
  return 𝒅ₕ, 𝑒
end
