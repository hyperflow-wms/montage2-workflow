REPO_NAME = 'montage-worker'
PREFIX = 'hyperflowwms'
MONTAGE_VERSION = '6.0'
HF_JOB_EXECUTOR_VERSION = '1.4.0'
TAG = '$(MONTAGE_VERSION)-je$(HF_JOB_EXECUTOR_VERSION)'

all: push

container: image

image:
	docker build --no-cache --build-arg hf_job_executor_version=$(HF_JOB_EXECUTOR_VERSION) -t $(PREFIX)/$(REPO_NAME):$(TAG) .
	docker tag $(PREFIX)/$(REPO_NAME):$(TAG) $(PREFIX)/$(REPO_NAME):$(MONTAGE_VERSION)-latest

push: image
	docker push $(PREFIX)/$(REPO_NAME):$(TAG)
	docker push $(PREFIX)/$(REPO_NAME):$(MONTAGE_VERSION)-latest

clean:
