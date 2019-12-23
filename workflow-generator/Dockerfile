FROM mhart/alpine-node:12

LABEL maintainer "Bartosz Balis <balis@agh.edu.pl>"

RUN apk add --no-cache make gcc g++ libnsl libnsl-dev
RUN apk add python py-pip unzip


ADD https://github.com/Caltech-IPAC/Montage/archive/master.zip / 

RUN unzip /master.zip && \
    rm -f /master.zip && \
    mv /Montage-master /Montage && \
    cd /Montage && \
    make

RUN apk add python-dev
RUN pip install astropy

RUN mkdir /montage-workflow-v2

ADD . /montage-workflow-v2/

RUN npm install https://github.com/hyperflow-wms/pegasus-hyperflow-converter/archive/master.tar.gz /

ENV PATH /Montage/bin:/montage-workflow-v2:/node_modules/.bin:$PATH
ENV PYTHONPATH=/montage-workflow-v2
