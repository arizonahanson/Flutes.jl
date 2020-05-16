FROM julia:1.4
COPY . /flutes
RUN cd /flutes
CMD ["julia"]

