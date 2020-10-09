FROM hyperflowwms/montage2-alpine-node-12:montage5.0

# Version of the job executor should be passed via docker build, e.g.: 
# docker build --build-arg hf_job_executor_version="v1.0.16""
ARG hf_job_executor_version

ENV HYPERFLOW_JOB_EXECUTOR_VERSION=$hf_job_executor_version

RUN npm -g install -g https://github.com/hyperflow-wms/hyperflow-job-executor/archive/${HYPERFLOW_JOB_EXECUTOR_VERSION}.tar.gz
