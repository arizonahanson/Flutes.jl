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
function lop(𝒍)
  return 𝒍[1:end-1]
end

# error function factory (constraints)
function mkerrfn(flute::FluteConstraint)
  ⇴ = lop ∘ mapflute
  𝒉 = flute.holes
  ħ = length(𝒉)
  𝒑₋ = map(ℎ->ℎ.𝑝₋, 𝒉)
  𝒑₊ = map(ℎ->ℎ.𝑝₊, 𝒉)
  𝒅₊ = map(ℎ->ℎ.𝑑₊, 𝒉)
  𝒍max = flute⇴ 𝒅₊
  function errfn(𝒅)
    𝒅mean = fill(mean(𝒅), ħ)
    𝒍 = flute⇴ 𝒅
    𝒍mean = flute⇴ 𝒅mean
    𝒍prev = [0.0; lop(𝒍)]
    𝛬max = ΣΔ(𝒍max, 𝒍)
    𝛬mean = ΣΔ(𝒍mean, 𝒍)
    𝛬box = Σ∇(𝒍prev+𝒑₋, 𝒍prev+𝒑₊, 𝒍) # location box
    𝑒 = 𝛬max + 3𝛬mean + (𝛬box + 1)^3
    return 𝑒
  end
  return errfn
end

function minbox(flute::FluteConstraint)
  𝒅₋ = map(𝒉->𝒉.𝑑₋, flute.holes)
  𝒅₊ = map(𝒉->𝒉.𝑑₊, flute.holes)
  𝒅₀ = map((𝑑₊, 𝑑₋)->0.75(𝑑₊-𝑑₋)+𝑑₋, 𝒅₊, 𝒅₋)
  return (𝒅₋, 𝒅₊, 𝒅₀)
end

function optimal(flute; trace=false)
  # minimize error function
  errfn = mkerrfn(flute)
  # box-constrained, initial parameters
  lower, upper, initial = minbox(flute)
  n_particles = length(initial)+3
  # particle swarm optimization
  result = optimize(errfn, initial,
                    ParticleSwarm(lower, upper, n_particles),
                    Optim.Options(iterations=100000, show_trace=trace, show_every=10000))
  params = Optim.minimizer(result)
  return params
end
