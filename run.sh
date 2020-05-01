#!/bin/bash
# This script runs everything in containers, so that you only need Docker on your host machine

echo Before running this script, start Redis container as follows:
echo docker run -d --name redis redis --bind 127.0.0.1
echo

docker run -a stdout -a stderr --rm --network container:redis -e HF_VAR_WORKER_CONTAINER="hyperflowwms/montage2-workflow-worker" -e HF_VAR_WORK_DIR="$PWD/data" -e HF_VAR_HFLOW_IN_CONTAINER="true" -e HF_VAR_function="redisCommand" -e REDIS_URL="redis://127.0.0.1:6379" --name hyperflow -v /var/run/docker.sock:/var/run/docker.sock -v $PWD:/wfdir --entrypoint "/bin/sh" hyperflowwms/hyperflow -c "apk add docker && hflow run /wfdir"
