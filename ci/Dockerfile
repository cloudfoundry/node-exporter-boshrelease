FROM bosh/docker-cpi:main

# Install all necessary tools for haproxy testflight and dependency autobump
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y wget jq git vim nano && \
    apt-get clean

# Set bosh env at login
RUN echo "source /tmp/local-bosh/director/env" >> /root/.bashrc

# Install go dependencies
ENV GOBIN=/usr/local/bin
RUN go install github.com/geofffranks/spruce/cmd/spruce@latest
