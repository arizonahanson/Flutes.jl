export optimal
using Optim
using Statistics


# sum of absolute differences (element-wise)
function Δ⃯(𝒄₁, 𝒄₂)
  return sum(map(abs, 𝒄₁- 𝒄₂))
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

# generate error function with scoped constants
function mkerrfn(flute::FluteConstraint)
  ⇴ = drop ∘ mapflute
  ⥆ = drop ∘ vcat
  𝒇 = flute.𝒇
  𝒑₋ = flute.𝒑₋
  𝒑₊ = flute.𝒑₊
  𝒅₊ = flute.𝒅₊
  𝒍⃯ = 𝒇⇴ 𝒅₊
  function errfn(𝒅)
    # locations
    𝒍 = 𝒇⇴ 𝒅
    𝒍̲ = 𝒇⇴ avg(𝒅)
    𝒍⃮ = 0.0⥆ 𝒍
    𝒍⃭ = 𝒍⃮+𝒑₋
    𝒍⃬ = 𝒍⃮+𝒑₊
    # error terms
    𝑒̲ = Δ⃯(𝒍, 𝒍̲)
    𝑒⃯ = Δ⃯(𝒍, 𝒍⃯)
    𝑒͍ = Δ͍(𝒍, 𝒍⃭, 𝒍⃬)^2
    # sum and weigh
    𝑒 = 𝑒̲ + 2𝑒⃯ + 3𝑒͍
    return 𝑒
  end
  return errfn
end

function minbox(flute::FluteConstraint)
  𝒅₋ = flute.𝒅₋
  𝒅₊ = flute.𝒅₊
  𝒅₀ = map((𝑑₊, 𝑑₋)->0.9(𝑑₊-𝑑₋)+𝑑₋, 𝒅₊, 𝒅₋)
  return (𝒅₋, 𝒅₊, 𝒅₀)
end

function optimal(flute; trace=false)
  # minimize error function
  errfn = mkerrfn(flute)
  # box-constrained, initial parameters
  lower, upper, initial = minbox(flute)
  # simulated annealing
  result = optimize(errfn, lower, upper, initial,
                    SAMIN(rt=0.97),
                    Optim.Options(iterations=Int(3e5), show_trace=trace, show_every=Int(2e4)))
  params = Optim.minimizer(result)
  return params
end
