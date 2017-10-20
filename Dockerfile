#########################################
#
# This Docker image is the Panorama Agent
#
#########################################
FROM centos:7

# Install components we need (log_packager.sh:net-tools)
RUN yum update -y && yum install -y net-tools && yum clean all -y

# Create our top-level directory
RUN mkdir -p /opt/riverbed/appinternals \
 && chmod g+w /opt/riverbed/appinternals \
 && chmod o+w /opt/riverbed/appinternals \
 && chgrp root /opt/riverbed/appinternals 

# Make sure we can write a log file
RUN mkdir -p /kit/log \
 && chmod g+w /kit/log \
 && chmod o+w /kit/log

# This records our version inside the container, for more visibility
ARG agent_ver
ENV RVBD_AGENT_VERSION=$agent_ver
ENV RVBD_AGENT_INTERNAL_CONTAINER=1

CMD ["/kit/rvbd-agent.sh"]

HEALTHCHECK --interval=30s --retries=1 CMD /opt/riverbed/appinternals/instrumentation/CurrentVersion/bin/agent status || exit 1

EXPOSE 2111 7072 33000

# Copy the kit into the container
COPY ["PanoT.tgz", "PanoU.tgz", "version", "mn/docker/rvbd-agent.sh", "/kit/"]

# We need the startup script to be executable
RUN chmod +x /kit/rvbd-agent.sh

# Keep this VOLUME instruction after all COPY commands, or the files will be lost
VOLUME /opt/riverbed
