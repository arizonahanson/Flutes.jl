export optimal
using Optim
using Statistics


# sum of elementwise differences
function ΣΔ(𝒍ₓ, 𝒍)
  return sum(map((ℓₓ, ℓ)->abs(ℓₓ-ℓ), 𝒍ₓ, 𝒍))
end

# sum of distance outside box
function Σ∇(𝒍₋, 𝒍₊, 𝒍)
  return sum(map((ℓ₋, ℓ₊, ℓ)->max(ℓ₋-ℓ, 0.0, ℓ-ℓ₊), 𝒍₋, 𝒍₊, 𝒍))
end

# return all but last element
function drop(𝒍)
  return 𝒍[1:end-1]
end

# return 𝒍 with ℓ as first element inserted
function push(ℓ, 𝒍)
  return [ℓ; 𝒍]
end

function norm(𝒅, ħ)
  return fill(mean(𝒅), ħ)
end

# error function factory (constraints)
function mkerrfn(flute::FluteConstraint)
  ⇴ = drop ∘ mapflute
  ⬰ = drop ∘ push
  𝒉 = flute.holes
  ħ = length(𝒉)
  𝒇 = [map(ℎ->ℎ.𝑓, 𝒉); flute.𝑓]
  𝒑₋ = map(ℎ->ℎ.𝑝₋, 𝒉)
  𝒑₊ = map(ℎ->ℎ.𝑝₊, 𝒉)
  𝒅₊ = map(ℎ->ℎ.𝑑₊, 𝒉)
  𝒍dmax = 𝒇⇴ 𝒅₊
  function errfn(𝒅)
    𝒍 = 𝒇⇴ 𝒅
    𝒍mean = 𝒇⇴ norm(𝒅, ħ)
    𝒍prev = 0.0⬰ 𝒍
    𝒍pmax = 𝒍prev+𝒑₊
    𝒍pmin = 𝒍prev+𝒑₋
    𝛬mean = ΣΔ(𝒍mean, 𝒍)
    𝛬max = ΣΔ(𝒍dmax, 𝒍)
    𝛬box = Σ∇(𝒍pmin, 𝒍pmax, 𝒍)
    𝑒 = 𝛬mean + 2𝛬max + 3𝛬box^2
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
                    SAMIN(rt=0.97, x_tol=1e-4, f_tol=1e-6),
                    Optim.Options(iterations=Int(2e5), show_trace=trace, show_every=Int(2e4)))
  params = Optim.minimizer(result)
  return params
end
