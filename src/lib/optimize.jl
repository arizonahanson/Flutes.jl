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

# all but last element
function plop(𝒍)
  return 𝒍[1:end-1]
end

# error function factory (constraints)
function mkerrfn(flute::FluteConstraint)
  𝒍max = plop(mapflute(flute, map(𝒉->𝒉.𝑑₊, flute.holes))) # positions of max diameters
  function errfn(𝒅)
    𝒍 = plop(mapflute(flute, 𝒅)) # hole positions
    𝒍mean = plop(mapflute(flute, fill(mean(𝒅), length(flute.holes))) # positions of mean diameters
    𝒍prev = prepend!(plop(𝒍), 0.0)
    𝒍close = map((ℓₚ, 𝒉)->ℓₚ+𝒉.𝑝₋, 𝒍prev, flute.holes)
    𝒍far = map((ℓₚ, 𝒉)->ℓₚ+𝒉.𝑝₊, 𝒍prev, flute.holes)
    𝑒 = ΣΔ(𝒍max, 𝒍) + ΣΔ(𝒍mean, 𝒍) + 2*Σ∇(𝒍close, 𝒍far, 𝒍)^2
    return 𝑒
  end
  return errfn
end

function minbox(flute::FluteConstraint)
  𝒅₋ = map(𝒉->𝒉.𝑑₋, flute.holes)
  𝒅₊ = map(𝒉->𝒉.𝑑₊, flute.holes)
  𝒅₀ = map(𝒅->0.9𝒅, (𝒅₊-𝒅₋)) + 𝒅₋
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
