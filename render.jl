
import Pkg;
Pkg.add("Mustache")
Pkg.add("JSON")
using Mustache
using JSON

# args = [outfile, infile, json]
function apply(args)
  io = open(args[1], "w")
  vals = JSON.parsefile(args[3])
  cd(dirname(args[2]))
  str = render_from_file(basename(args[2]), vals)
  write(io, str)
  close(io)
end

apply(ARGS)

