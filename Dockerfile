FROM OSX / Linux / Cygwin
RUN ./docker/go.sh
CMD ["/bin/bash", "-D"]
