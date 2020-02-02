
import Pkg;
Pkg.add("Mustache")
Pkg.add("JSON")
using Mustache
using JSON

# args = [outfile, infile, json]
function apply(args)
  io = open(args[1], "w")
  str = render_from_file(args[2], JSON.parsefile(args[3]))
  write(io, str)
  close(io)
end

apply(ARGS)

