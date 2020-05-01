FROM mhart/alpine-node:12

ENV HYPERFLOW_JOB_EXECUTOR_VERSION=v1.0.11

RUN apk add --no-cache make gcc g++ libnsl libnsl-dev
RUN npm install -g https://github.com/hyperflow-wms/hyperflow-job-executor/archive/${HYPERFLOW_JOB_EXECUTOR_VERSION}.tar.gz
RUN cd / && \
    wget -nv https://github.com/Caltech-IPAC/Montage/archive/master.zip && \
    unzip master.zip && \
    rm -f master.zip && \
    mv Montage-master Montage && \
    cd Montage && \
    make && \
    rm -rf MontageLib && \
    rm -rf Montage

ENV PATH $PATH:/Montage/bin:/node_modules/.bin
