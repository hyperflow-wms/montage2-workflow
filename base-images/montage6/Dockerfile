FROM node:20-bookworm-slim

# Install system dependencies for building Montage
RUN apt-get update && apt-get install -y \
    wget \
    gcc \
    g++ \
    make \
    patch \
    libnsl-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Montage toolkit v6.0.
#
# changes.patch adds -fcommon to every Makefile whose module relies on
# tentative definitions of globals. gcc 10+ defaults to -fno-common, and
# without the flag those modules fail to link.
#
# Montage's make ignores per-module failures and still exits 0, so
# check-tools.sh runs after the install and fails the build if any tool the
# workflow needs is missing.
WORKDIR /tmp
COPY changes.patch check-tools.sh ./
RUN wget http://montage.ipac.caltech.edu/download/Montage_v6.0.tar.gz && \
    tar -xzf Montage_v6.0.tar.gz && \
    cd Montage && \
    echo "Patching Makefiles to add -fcommon..." && \
    patch -p1 < ../changes.patch && \
    echo "Building Montage v6.0..." && \
    make && \
    echo "Copying binaries to /usr/local/bin..." && \
    cp -v bin/* /usr/local/bin/ && \
    sh ../check-tools.sh && \
    echo "Installation complete" && \
    cd .. && \
    rm -rf Montage Montage_v6.0.tar.gz changes.patch check-tools.sh

# Set Montage environment
ENV MONTAGE_HOME=/usr/local

WORKDIR /
