# called by docker build to trigger package download
using Pkg;
Pkg.activate(".")
Pkg.instantiate()

