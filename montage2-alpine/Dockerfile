FROM mhart/alpine-node:12

RUN apk add --no-cache make gcc g++ libnsl libnsl-dev freetype
WORKDIR /
ADD Montage-master.tar.gz /
COPY patches.diff /
RUN mv Montage-master Montage && \
    cd Montage && \
    patch -p1 < ../patches.diff && \
    make && \
    rm -rf MontageLib && \
    rm -rf Montage

ENV PATH $PATH:/Montage/bin
