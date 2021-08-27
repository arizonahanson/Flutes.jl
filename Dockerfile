FROM julia
COPY . /Flutes
WORKDIR /Flutes
RUN julia -e 'using Pkg; Pkg.activate("."); Pkg.instantiate()'
CMD ["julia"]
