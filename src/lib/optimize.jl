export optimal
using Optim
using Statistics

# error function factory (constraints)
function mkerrfn(flute::FluteConstraint)
  # list of frequencies in descending pitch
  H = length(flute.holes)
  𝒍big = mapflute(flute, map(𝒉->𝒉.𝑑₊, flute.holes))
  function errfn(𝒅)
    𝑒 = 0.0 # error result
    𝒍 = mapflute(flute, 𝒅) # hole positions
    𝒍avg = mapflute(flute, fill(mean(𝒅), H))
    for h in 1:H # body->foot order
      # for each tonehole calculate error based on preferences
      ℓₕ = 𝒍[h] # resulting location
      # deviation from reachable
      𝒉 = flute.holes[h]
      ℓₚ = h > 1 ? 𝒍[h-1] : 0.0 # previous hole position
      𝛬crowd = ℓₚ - ℓₕ + 𝒉.𝑝₋ # positive if location below min
      𝛬stretch = ℓₕ - ℓₚ - 𝒉.𝑝₊ # positive if location above max
      𝛬reach = max(𝛬crowd, 0.0, 𝛬stretch)
      # deviation from max hole diameter (prefer larger diameters)
      𝛬big = abs(𝒍big[h] - ℓₕ)
      # deviation from mean hole diameter (prefer average diameters)
      𝛬avg = abs(𝒍avg[h] - ℓₕ)
      # sum weighted errors (heavy weight on reachable locations)
      𝑒 += 2𝛬reach^2 + 𝛬big + 2𝛬avg
    end
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
