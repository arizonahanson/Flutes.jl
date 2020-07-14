export optimal
using Optim
using Statistics


# sum of elementwise differences
function Δ⃯(𝒄₁, 𝒄₂)
  return sum(map(abs, 𝒄₁- 𝒄₂))
end

# sum of distance outside box
function Δ͍(𝒄, 𝒄₋, 𝒄₊)
  return sum(max.(𝒄₋-𝒄, 0.0, 𝒄-𝒄₊))
end

# return all but last element
function front(𝒄)
  return 𝒄[1:end-1]
end

# same-length collection of average value
function avg(𝒄)
  return fill(mean(𝒄), length(𝒄))
end

# error function factory (constraints)
function mkerrfn(flute::FluteConstraint)
  ⇴ = front ∘ mapflute
  ⬰ = front ∘ vcat
  𝒉 = flute.holes
  𝒇 = [map(ℎ->ℎ.𝑓, 𝒉); flute.𝑓]
  𝒑₋ = map(ℎ->ℎ.𝑝₋, 𝒉)
  𝒑₊ = map(ℎ->ℎ.𝑝₊, 𝒉)
  𝒅₊ = map(ℎ->ℎ.𝑑₊, 𝒉)
  𝒍⃯ = 𝒇⇴ 𝒅₊
  function errfn(𝒅)
    # locations
    𝒍 = 𝒇⇴ 𝒅
    𝒍̲ = 𝒇⇴ avg(𝒅)
    𝒍⃮ = 0.0⬰ 𝒍
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
  𝒅₋ = map(𝒉->𝒉.𝑑₋, flute.holes)
  𝒅₊ = map(𝒉->𝒉.𝑑₊, flute.holes)
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
                    Optim.Options(iterations=Int(2e5), show_trace=trace, show_every=Int(2e4)))
  params = Optim.minimizer(result)
  return params
end
