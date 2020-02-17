#!/usr/bin/env julia

import Pkg; Pkg.add("Optim")
using Optim

function f(x) #rosenbrock example
  (1.0 - x[1])^2 + 100.0 * (x[2] - x[1]^2)^2
end

function main()
  lower = [1.0, 1.0]
  upper = [10.0, 10.0]
  initial = [5.0, 5.0]
  solver = LBFGS()
  results = optimize(f, lower, upper, initial, Fminbox(solver);
                     autodiff=:forward)
  println(results)
end

main()
