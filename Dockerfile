FROM julia
COPY . /Flutes
RUN cd /Flutes
RUN julia -e 'using Pkg; Pkg.activate("."); Pkg.instantiate()'
CMD ["julia"]
