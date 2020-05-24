FROM mhart/alpine-node:12

RUN apk add --no-cache make gcc g++ libnsl libnsl-dev freetype
RUN cd / && \
    wget -nv https://github.com/Caltech-IPAC/Montage/archive/master.zip && \
    unzip master.zip && \
    rm -f master.zip && \
    mv Montage-master Montage && \
    cd Montage && \
    make && \
    rm -rf MontageLib && \
    rm -rf Montage

ENV PATH $PATH:/Montage/bin
