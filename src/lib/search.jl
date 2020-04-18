export FluteConstraint, ToneHoleConstraint
export optimal, createflute, addtonehole!
using Optim
using Statistics

struct FluteConstraint
  𝑓  # lowest frequency
  holes
end

struct ToneHoleConstraint
  𝑓  # hole frequency
  𝑑₋ # min diameter
  𝑑₊ # max diameter
  𝑝₋ # min separation
  𝑝₊ # max separation
end

function addtonehole!(flute::FluteConstraint, 𝑓; 𝑑₋=2.0, 𝑑₊=9.0, 𝑝₋=15.0, 𝑝₊=40.0)
  push!(flute.holes, ToneHoleConstraint(𝑓, 𝑑₋, 𝑑₊, 𝑝₋, 𝑝₊))
end

function createflute(𝑓)
  return FluteConstraint(𝑓, [])
end

# error function factory (constraints)
function mkerrfn(flute::FluteConstraint)
  # return error function
  𝑯 = 1:length(flute.holes)
  ℓₜ = flutelength(flute.𝑓)
  function errfn(𝒅)
    𝑒 = 0.0 # error
    ℓᵩ = 0.0 # length of last hole, or embouchure
    𝛥ℓᵪ = 0.0 # closed-hole correction
    𝑑mean = mean(𝒅)
    for h in 𝑯
      # for each tonehole calculate error
      𝒉 = flute.holes[h]
      𝑑ₕ = 𝒅[h]
      ℓₕ = toneholelength(𝒉.𝑓; 𝑑=𝑑ₕ)-𝛥ℓᵪ
      # distance from absolute max hole position
      𝛬ℓ₊ = abs(toneholelength(𝒉.𝑓; 𝑑=𝒉.𝑑₊)-𝛥ℓᵪ - ℓₕ)
      # distance outside reachable range
      ℓₕmin = ℓᵩ - ℓₕ + 𝒉.𝑝₋ # positive if distance below min
      ℓₕmax = ℓₕ - ℓᵩ - 𝒉.𝑝₊ # positive if distance above max
      𝛬ℓout = max(ℓₕmin, 0.0, ℓₕmax)
      # distance from mean hole-size
      𝛬ℓmean = abs(toneholelength(𝒉.𝑓; 𝑑=𝑑mean)-𝛥ℓᵪ - ℓₕ)
      # sum weighted errors
      𝑒 += 2𝛬ℓout^2 + 0.618𝛬ℓ₊ + 𝛬ℓmean
      # calculate increased correction for next loop
      𝛥ℓᵪ += closedholecorrection(𝒉.𝑓; 𝑑=𝑑ₕ, ℓᵣ=ℓₜ-ℓₕ)
      # next loop use this hole as previous hole
      ℓᵩ = ℓₕ
    end
    return 𝑒
  end
  return errfn
end

function minbox(flute::FluteConstraint)
  𝒅₋ = map(𝒉->𝒉.𝑑₋, flute.holes)
  𝒅₊ = map(𝒉->𝒉.𝑑₊, flute.holes)
  𝒅₀ = map(𝒅->𝒅*rand(), (𝒅₊-𝒅₋)) + 𝒅₋
  return (𝒅₋, 𝒅₊, 𝒅₀)
end

function optimal(flute)
  # minimize error function
  errfn = mkerrfn(flute)
  # box-constrained, initial parameters
  minp, maxp, initp = minbox(flute)
  result = optimize(errfn, minp, maxp, initp, Fminbox(LBFGS()))
  # check for convergence
  if !Optim.converged(result)
    println("unable to converge on a result")
  else
    println(result)
  end
  params = Optim.minimizer(result)
  # return minimizer
  return params
end
