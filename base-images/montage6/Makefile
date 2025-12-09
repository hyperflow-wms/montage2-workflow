REPO_NAME = 'montage-base'
PREFIX = 'hyperflowwms'
MONTAGE_VERSION = '6.0'
NODE_VERSION = 'node20'
TAG = '$(MONTAGE_VERSION)-$(NODE_VERSION)'

all: push

container: image

image:
	docker build --no-cache -t $(PREFIX)/$(REPO_NAME):$(TAG) .
	docker tag $(PREFIX)/$(REPO_NAME):$(TAG) $(PREFIX)/$(REPO_NAME):$(MONTAGE_VERSION)-latest

push: image
	docker push $(PREFIX)/$(REPO_NAME):$(TAG)
	docker push $(PREFIX)/$(REPO_NAME):$(MONTAGE_VERSION)-latest

clean:
