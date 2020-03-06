export findflute

function mkflute(freqs, diams)
  # TODO: generate flute
end

# error function factory (other-constraints)
function mkerrfn(freqs, minpaddings, maxpaddings)
  # return error function
  function errfn(diams)
    # generate flute
    flute = mkflute(freqs, diams)
    # TODO: calculate error
  end
  return errfn
end

function dosearch(errfn, mindiameters, maxdiameters, initdiameters)
  # minimize error function
  solver = LBGFS()
  result = optimize(errfn, mindiameters, maxdiameters, initdiameters,
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
             minpaddings:Array<Float64>,
             maxpaddings:Array<Float64>,
            mindiameters:Array<Float64>,
            maxdiameters:Array<Float64>,
           initdiameters:Array<Float64>)
  # error function
  errfn = mkerrfn(scale, minpaddings, maxpaddings)
  # find optimal diameter set
  diams = dosearch(errfn, mindiameters, maxdiameters, initdiameters)
  # return result
  return mkflute(scale, diams)
end
