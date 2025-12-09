#!/bin/sh

docker run -v $PWD:/workdir hyperflowwms/montage2-generator sh -c 'cd /workdir && generate-workflow --center "15.09552 -0.74559" --degrees 2.0 --band 2mass:j:red --band 2mass:h:green --band 2mass:k:blue'
