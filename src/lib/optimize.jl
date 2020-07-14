export optimal
using Optim
using Statistics


# sum of elementwise differences
function Δ⃯(𝒍₁, 𝒍₂)
  return sum(map(abs, 𝒍₂- 𝒍₁))
end

# sum of distance outside box
function Δ͍(𝒍, 𝒍₋, 𝒍₊)
  return (sum(map((ℓ₋, ℓ₊, ℓ)->max(ℓ₋-ℓ, 0.0, ℓ-ℓ₊), 𝒍₋, 𝒍₊, 𝒍)) + 1)^2 - 1
end

# return all but last element
function drop(𝒍)
  return 𝒍[1:end-1]
end

# return 𝒍 with ℓ as first element inserted
function push(ℓ, 𝒍)
  return [ℓ; 𝒍]
end

function avg(𝒅)
  return fill(mean(𝒅), length(𝒅))
end

# error function factory (constraints)
function mkerrfn(flute::FluteConstraint)
  ⇴ = drop ∘ mapflute
  ⬰ = drop ∘ push
  𝒉 = flute.holes
  𝒇 = [map(ℎ->ℎ.𝑓, 𝒉); flute.𝑓]
  𝒑₋ = map(ℎ->ℎ.𝑝₋, 𝒉)
  𝒑₊ = map(ℎ->ℎ.𝑝₊, 𝒉)
  𝒅₊ = map(ℎ->ℎ.𝑑₊, 𝒉)
  𝒍⃯ = 𝒇⇴ 𝒅₊
  function errfn(𝒅)
    # locations
    𝒍  = 𝒇⇴ 𝒅
    𝒍ᵪ̅ = 𝒇⇴ avg(𝒅)
    𝒍⃮  = 0.0⬰ 𝒍
    𝒍͍₋ = 𝒍⃮+𝒑₋
    𝒍͍₊ = 𝒍⃮+𝒑₊
    # error terms
    𝑒ᵪ̅ = Δ⃯(𝒍, 𝒍ᵪ̅)
    𝑒⃯  = Δ⃯(𝒍, 𝒍⃯)
    𝑒͍  = Δ͍(𝒍, 𝒍͍₋, 𝒍͍₊)
    # sum and weigh
    𝑒  = 𝑒ᵪ̅ + 2𝑒⃯ + 3𝑒͍
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
