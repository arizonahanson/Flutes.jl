export FluteConstraint, ToneHoleConstraint
export optimal, createflute, addtonehole
using Optim

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

function addtonehole!(flute::FluteConstraint, 𝑓; 𝑑₋=1.0, 𝑑₊=12.0, 𝑝₋=15.0, 𝑝₊=30.0)
  push!(flute.holes, ToneHoleConstraint(𝑓, 𝑑₋, 𝑑₊, 𝑝₋, 𝑝₊))
end

function createflute(𝑓)
  return FluteConstraint(𝑓, [])
end

function createflute()
  f = createflute(note("D4"))
  addtonehole!(f, note("F4"))
  addtonehole!(f, note("G4"))
  addtonehole!(f, note("A4"))
  addtonehole!(f, note("C5"))
  addtonehole!(f, note("D5"))
  return f
end

# error function factory (constraints)
function mkerrfn(flute::FluteConstraint)
  # return error function
  ℓₜ= flutelength(flute.𝑓)
  function errfn(params)
    ϵ = 0.0
    ℓₓ = ℓₜ # length of last hole, or flute
    for h in 1:length(params)
      # for each hole calculate error
      𝒉 = flute.holes[h]
      𝑑ₕ = params[h]
      ℓₕ = toneholelength(𝒉.𝑓; 𝑑=𝑑ₕ)
      # target max hole diameter (convert to length)
      ℓ₊ = toneholelength(𝒉.𝑓; 𝑑=𝒉.𝑑₊)
      λℓₕ = ℓ₊ - ℓₕ
      # constrain distance to last hole, or flute end
      λ𝑝ₕ = 0.0
      𝑝ₕ = ℓₓ - ℓₕ
      if 𝑝ₕ > 𝒉.𝑝₊
        # above maximum distance
        λ𝑝ₕ = 𝑝ₕ - 𝒉.𝑝₊
      elseif 𝑝ₕ < 𝒉.𝑝₋
        # below minimum distance
        λ𝑝ₕ = 𝒉.𝑝₋ - 𝑝ₕ
      end
      # sum weighted errors
      ϵ += λℓₕ^2 + 2λ𝑝ₕ^2
      # next loop use this hole as last hole
      ℓₓ = ℓₕ
    end
    return ϵ
  end
  return errfn
end

function minbox(flute::FluteConstraint)
  𝒅₋ = map(𝒉->𝒉.𝑑₋, flute.holes)
  𝒅₊ = map(𝒉->𝒉.𝑑₊, flute.holes)
  𝒅₀ = 𝒅₋ * 2
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
    println("warning: unable to converge on a result")
  end
  println(result)
  # return minimizer
  return map(𝑑->round(𝑑; digits=2), Optim.minimizer(result))
end
