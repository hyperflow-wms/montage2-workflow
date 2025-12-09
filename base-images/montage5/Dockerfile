FROM mhart/alpine-node:12

RUN apk add --no-cache make gcc g++ libnsl libnsl-dev freetype
WORKDIR /
ADD Montage-master.tar.gz /
COPY patches.diff /
RUN mv Montage-master Montage && \
    cd Montage && \
    make

ENV PATH $PATH:/Montage/bin
