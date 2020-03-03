
module Flutes
include("Notes.jl")

function mkflute(freqs, diams)
  # TODO: generate flute
end

# error function factory (other-constraints)
function mkerrfn(freqs, minpad, maxpad)
  # return error function
  function errfn(diams)
    # generate flute
    flute = mkflute(freqs, diams)
    # TODO: calculate error
  end
  return errfn
end

function dosearch(errfn, mindiam, maxdiam, initial)
  # minimize error function
  solver = LBGFS()
  result = optimize(errfn, mindiam, maxdiam, initial,
                    Fminbox(solver), autodiff=:forward)
  # check for convergence
  if !converged(result)
    println("warning: unable to converge on a solution")
  end
  # return minimizer
  return minimizer(result)
end

"""
search for flute with constraints
"""
function findflute(scale:Array<Float64>,
                  minpad:Array<Float64>,
                  maxpad:Array<Float64>,
                 mindiam:Array<Float64>,
                 maxdiam:Array<Float64>,
                 initial:Array<Float64>)
  # error function
  errfn = mkerrfn(scale, minpad, maxpad)
  # find optimal diameter set
  diams = dosearch(errfn, mindiam, maxdiam, initial)
  # return result
  return mkflute(scale, diams)
end

export findflute
end
