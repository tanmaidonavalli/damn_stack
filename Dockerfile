FROM
RUN chmod 755 /docker/all.sh && \
    ./docker/tfrun.sh
CMD ["/bin/bash", "-D"]
