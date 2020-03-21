export FluteConstraint, ToneHoleConstraint
export optimal, createflute, addtonehole
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

function createflute()
  f = createflute(note("D4"))
  addtonehole!(f, note("E4"); 𝑝₊=Inf, 𝑑₊=7.0)
  addtonehole!(f, note("F4"); 𝑝₊=24.0)
  addtonehole!(f, note("G4"))
  addtonehole!(f, note("A4"))
  addtonehole!(f, note("B♭4");𝑝₊=Inf)
  addtonehole!(f, note("C5"))
  addtonehole!(f, note("D5"))
  return f
end

# error function factory (constraints)
function mkerrfn(flute::FluteConstraint)
  # return error function
  ℓₜ= flutelength(flute.𝑓)
  𝑯 = 1:length(flute.holes)
  𝒍₊ = map(𝒉->toneholelength(𝒉.𝑓; 𝑑=𝒉.𝑑₊), flute.holes)
  function errfn(𝒅)
    ϵ = 0.0
    ℓᵩ = ℓₜ # length of last hole, or flute
    𝑑mean = mean(𝒅)
    for h in 𝑯
      # for each hole calculate error
      𝒉 = flute.holes[h]
      ℓₕ = toneholelength(𝒉.𝑓; 𝑑=𝒅[h])
      # distance from absolute max hole position
      λℓ₊ = abs(𝒍₊[h] - ℓₕ)
      # distance outside reachable range
      ℓmin = ℓᵩ - ℓₕ - 𝒉.𝑝₊
      ℓmax = ℓₕ - ℓᵩ - 𝒉.𝑝₋
      λℓout = max(ℓmin, 0.0, ℓmax)
      # distance from next hole with padding
      λℓprev = abs(ℓmax)
      # distance from mean hole-size
      λℓmean = abs(toneholelength(𝒉.𝑓; 𝑑=𝑑mean) - ℓₕ)
      # sum weighted errors
      ϵ += 2λℓout^2 + 0.5λℓ₊ + λℓmean + λℓprev
      # next loop use this hole as last hole
      ℓᵩ = ℓₕ
    end
    return ϵ
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
  #println(result)
  params = Optim.minimizer(result)
  # return minimizer
  return map(𝑑->round(𝑑; digits=2), params)
end
