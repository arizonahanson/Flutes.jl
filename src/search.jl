export FluteConstraint, ToneHoleConstraint
export optimize, createflute, addtonehole

struct FluteConstraint
  𝑓  # lowest frequency
  holes::Array<ToneHoleConstraint>
end

struct ToneHoleConstraint
  𝑓  # hole frequency
  𝑑₋ # min diameter
  𝑑₊ # max diameter
  𝑝₋ # min separation
  𝑝₊ # max separation
end

function addtonehole!(flute::FluteConstraint, 𝑓; 𝑑₋=1, 𝑑₊=10, 𝑝₋=12, 𝑝₊=30)
  push!(flute.holes, ToneHoleConstraint(𝑓, 𝑑₋, 𝑑₊, 𝑝₋, 𝑝₊))
end

function createflute(𝑓)
  return FluteConstraint(𝑓, [])
end

function createflute()
  f = createflute(note("D4"))
  addtonehole!(f, note("F4"))
  addtonehole!(f, note("G4"))
  addtonehole!(f, note("A4"); 𝑝₊=1000)
  addtonehole!(f, note("C5"))
  addtonehole!(f, note("D5"))
  addtonehole!(f, note("F5"))
  return f
end

# error function factory (constraints)
function mkerrfn(flute::FluteConstraint)
  # return error function
  ℓₜ= flutelength(flute.𝑓)
  function errfn(params)
    ϵ = 0
    ℓₓ = ℓₜ # length of last hole, or flute
    for h in 1:length(params)
      # for each hole calculate error
      ℎ = flute.holes[h]
      𝑑ₕ = params[h]
      ℓₕ = toneholelength(ℎ.𝑓; 𝑑=𝑑ₕ)
      # constrain distance to last hole, or flute end
      λ𝑝ₕ = 0
      𝑝ₕ = ℓₓ - ℓₕ
      if 𝑝ₕ > ℎ.𝑝₊
        # above maximum distance
        λ𝑝ₕ = 𝑝ₕ - ℎ.𝑝₊
      elseif 𝑝ₕ < ℎ.𝑝₋
        # below minimum distance
        λ𝑝ₕ = ℎ.𝑝₋ - 𝑝ₕ
      end
      # target max hole diameter
      λ𝑑ₕ = ℎ.𝑑₊ - 𝑑ₕ
      # sum weighted errors
      ϵ += λ𝑑ₕ^2 + 2λ𝑝ₕ^2
      # next loop use this hole as last hole
      ℓₓ = ℓₕ
    end
    return ϵ
  end
  return errfn
end

function minbox(flute::FluteConstraint)
  𝒅₋ = map(flute.holes, ℎ->ℎ.𝑑₋)
  𝒅₊ = map(flute.holes, ℎ->ℎ.𝑑₊)
  𝒅₀ = (minparams+maxparams)/2
  return (𝒅₋, 𝒅₊, 𝒅₀)
end

function optimize(flute)
  # minimize error function
  errfn = mkerrfn(flute)
  # box-constrained, initial parameters
  minp, maxp, initp = minbox(flute)
  method = Fminbox(LBGFS())
  result = optimize(errfn, minp, maxp, initp, method, autodiff=:forward)
  # check for convergence
  if !converged(result)
    println("warning: unable to converge on a result")
  end
  # return minimizer
  return minimizer(result)
end
