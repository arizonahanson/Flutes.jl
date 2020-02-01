
import Pkg;
Pkg.add("Mustache")
Pkg.add("JSON")
using Mustache
using JSON

function apply(inpath, outpath, vars)
  str = render_from_file(inpath, vars)
  io = open(outpath, "w")
  write(io, str)
  close(io)
end

println(ARGS[2]*" -> "*ARGS[1]*".scad : "*ARGS[3])
apply(ARGS[2], ARGS[1]*".scad", JSON.parsefile(ARGS[3]))
