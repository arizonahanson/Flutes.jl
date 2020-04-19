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
  ℓₜ = flutelength(flute.𝑓)
  𝒇 = map(𝒉->𝒉.𝑓, flute.holes); push!(𝒇, flute.𝑓)
  𝑯 = 1:length(flute.holes)
  function errfn(𝒅)
    𝑒 = 0.0 # error
    ℓₚ = 0.0 # position of previous hole, or embouchure
    #𝛥ℓᵪ = 0.0 # closed-hole correction
    𝑑mean = mean(𝒅)
    for h in 𝑯
      # for each tonehole calculate error
      𝒉 = flute.holes[h]
      𝑓ₜ = 𝒇[h+1]
      𝑑ₕ = 𝒅[h]
      ℓₕ = toneholelength(𝒉.𝑓; 𝑓ₜ=𝑓ₜ, 𝑑=𝑑ₕ)#-𝛥ℓᵪ
      # distance outside reachable range
      𝛬ℓₚmin = ℓₚ - ℓₕ + 𝒉.𝑝₋ # positive if distance below min
      𝛬ℓₚmax = ℓₕ - ℓₚ - 𝒉.𝑝₊ # positive if distance above max
      𝛬ℓₚ = max(𝛬ℓₚmin, 0.0, 𝛬ℓₚmax)
      # distance from absolute max hole position
      𝛬ℓ₊ = abs(toneholelength(𝒉.𝑓; 𝑓ₜ=𝑓ₜ, 𝑑=𝒉.𝑑₊) - ℓₕ)#-𝛥ℓᵪ)
      # distance from mean hole-size
      𝛬ℓmean = abs(toneholelength(𝒉.𝑓; 𝑓ₜ=𝑓ₜ, 𝑑=𝑑mean) - ℓₕ)#-𝛥ℓᵪ)
      # sum weighted errors
      𝑒 += 2𝛬ℓₚ^2 + 0.618𝛬ℓ₊ + 𝛬ℓmean
      # calculate increased correction for next loop
      #𝛥ℓᵪ += closedholecorrection(𝒉.𝑓; 𝑓ₜ=𝑓ₜ, 𝑑=𝑑ₕ)
      # next loop use this hole as previous hole
      ℓₚ = ℓₕ
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
