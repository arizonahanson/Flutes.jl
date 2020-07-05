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
  𝒑₋ = map(𝒉->𝒉.𝑝₋, flute.holes)
  𝒑₊ = map(𝒉->𝒉.𝑝₊, flute.holes)
  𝒅₊ = map(𝒉->𝒉.𝑑₊, flute.holes)
  𝒍max = flute⇴ 𝒅₊ # positions of max diameters
  function errfn(𝒅)
    𝒍 = flute⇴ 𝒅 # hole positions
    𝒍mean = flute⇴ fill(mean(𝒅), length(flute.holes)) # positions of mean diameters
    𝒍prev = [0.0; lop(𝒍)]
    𝒍close = 𝒍prev + 𝒑₋
    𝒍far = 𝒍prev + 𝒑₊
    𝑒 = ΣΔ(𝒍max, 𝒍) + 2ΣΔ(𝒍mean, 𝒍) + 2*Σ∇(𝒍close, 𝒍far, 𝒍)^2
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
  n_particles = length(initial)*2
  # particle swarm optimization
  result = optimize(errfn, initial,
                    ParticleSwarm(lower, upper, n_particles),
                    Optim.Options(iterations=100000, show_trace=trace, show_every=10000))
  params = Optim.minimizer(result)
  return params
end
