FROM julia:1.5
COPY . /Flutes.jl
RUN cd /Flutes.jl; julia instantiate.jl
CMD ["julia"]
