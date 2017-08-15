#########################################
#
# This Docker image is the Panorama Agent
#
#########################################
FROM centos:7

# Copy the kit into the container
COPY mn/ /kit/Panorama/hedzup/mn
RUN chown -R dsa-user:dsa-user /kit/Panorama/hedzup/mn && \
    mkdir /opt/Panorama && \
    chown dsa-user:dsa-user /opt/Panorama

USER dsa-user
CMD /kit/Panorama/hedzup/mn/docker/CMD-agent.sh

EXPOSE 2111 7072 33000

# Keep this VOLUME instruction after all COPY commands, or the files will be lost
VOLUME /opt/Panorama
