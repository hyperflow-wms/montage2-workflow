#!/bin/sh

docker run -v $PWD:/workdir hyperflowwms/montage2-generator sh -c 'cd /workdir && generate-workflow --center "56.7 24.0" --degrees 2.0 --band dss:DSS2B:blue --band dss:DSS2R:green --band dss:DSS2IR:red'
