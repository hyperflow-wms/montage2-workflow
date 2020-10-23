FROM hyperflowwms/montage2-alpine-node-12:montage5.0

LABEL maintainer "Bartosz Balis <balis@agh.edu.pl>"

RUN apk add --no-cache bash python python-dev py-pip && \
    pip install astropy && \
    npm install -g https://github.com/hyperflow-wms/pegasus-hyperflow-converter/archive/master.tar.gz 

WORKDIR /montage-workflow-v2
COPY . .

ENV PATH /montage-workflow-v2:$PATH
ENV PYTHONPATH=/montage-workflow-v2
