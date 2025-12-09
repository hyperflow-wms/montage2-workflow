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

# Install Montage toolkit v6.0 with gcc compatibility patches
WORKDIR /tmp
COPY changes.patch .
RUN wget http://montage.ipac.caltech.edu/download/Montage_v6.0.tar.gz && \
    tar -xzf Montage_v6.0.tar.gz && \
    cd Montage && \
    echo "Patching Makefiles to add -fcommon flag for gcc 10+ compatibility..." && \
    patch -p1 < ../changes.patch && \
    #sed -i '51s/-std=c99$/-std=c99 -fcommon/' Montage/Makefile.LINUX && \
    #sed -i '3s/$/ -fcommon/' lib/src/coord/Makefile && \
    echo "Building Montage v6.0..." && \
    make && \
    echo "Copying binaries to /usr/local/bin..." && \
    cp -v bin/* /usr/local/bin/ && \
    echo "Installation complete" && \
    cd .. && \
    rm -rf Montage Montage_v6.0.tar.gz

# Set Montage environment
ENV MONTAGE_HOME=/usr/local

WORKDIR /
