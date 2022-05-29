FROM hyperflowwms/montage2-alpine-node-12:montage5.0-patched

# Version of the job executor should be passed via docker build, e.g.: 
# docker build --build-arg hf_job_executor_version="v1.0.16""
ARG hf_job_executor_version

ENV HYPERFLOW_JOB_EXECUTOR_VERSION=$hf_job_executor_version

RUN npm install -g @hyperflow/job-executor@${HYPERFLOW_JOB_EXECUTOR_VERSION}

# Required for running NodeJS application as process with non primary PID.
# NodeJS application with PID 1 are not properly receiving signals like SIGTERM
# https://github.com/nodejs/docker-node/blob/main/docs/BestPractices.md#handling-kernel-signals
RUN wget -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.5/dumb-init_1.2.5_x86_64
RUN chmod +x /usr/local/bin/dumb-init
ENTRYPOINT ["/usr/local/bin/dumb-init", "--"]