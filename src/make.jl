
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

apply(ARGS[2], ARGS[1], JSON.parsefile(ARGS[3]))
