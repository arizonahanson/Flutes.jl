FROM julia:1.6
COPY . /Flutes.jl
RUN cd /Flutes.jl \
  && julia -e 'using Pkg; Pkg.activate("."); Pkg.instantiate()'
CMD ["julia"]
