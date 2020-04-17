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
    𝑒 = 0.0
    ℓᵩ = 0.0 # length of last hole, or embouchure
    𝛥ℓ = 0.0 # closed-hole correction
    𝑑mean = mean(𝒅)
    for h in 𝑯
      # for each hole calculate error
      𝒉 = flute.holes[h]
      𝑑ₕ = 𝒅[h]
      ℓₕ = toneholelength(𝒉.𝑓; 𝑑=𝑑ₕ) - 𝛥ℓ
      # distance from absolute max hole position
      λℓ₊ = abs(toneholelength(𝒉.𝑓; 𝑑=𝒉.𝑑₊) - 𝛥ℓ - ℓₕ)
      # distance outside reachable range
      ℓmin = ℓₕ - ℓᵩ - 𝒉.𝑝₊
      ℓmax = ℓᵩ - ℓₕ - 𝒉.𝑝₋
      λℓout = max(ℓmin, 0.0, ℓmax)
      # distance from mean hole-size
      λℓmean = abs(toneholelength(𝒉.𝑓; 𝑑=𝑑mean) - 𝛥ℓ - ℓₕ)
      # sum weighted errors
      𝑒 += 2λℓout^2 + 0.618λℓ₊ + λℓmean
      # next loop use this hole as last hole
      ℓᵩ = ℓₕ
      𝛥ℓ += closedholecorrection(𝒉.𝑓; 𝑑=𝑑ₕ, ℓ𝑟=ℓₜ-ℓₕ)
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
  result = optimize(errfn, minp, maxp, initp, Fminbox(BFGS()))
  # check for convergence
  if !Optim.converged(result)
    println("warning: unable to converge on a result")
  end
  println(result)
  params = Optim.minimizer(result)
  # return minimizer
  return params
end
