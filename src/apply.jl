
using Mustache

export apply

function apply(inpath, outpath, vars)
  str = render_from_file(inpath, vars)
  io = open(outpath, "w")
  write(io, str)
  close(io)
end
