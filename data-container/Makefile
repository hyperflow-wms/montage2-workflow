SHELL := /bin/bash

ifndef WORKFLOW_DIR
$(error WORKFLOW_DIR is not set. Example, make push WORKFLOW_DIR=montage2-0.25 NUMBER_OF_TASKS=619)
endif

ifndef WORKFLOW_DEGREE
$(info Using default WORKFLOW_DEGREE=0.25)
WORKFLOW_DEGREE = 0.25
endif

ifndef NUMBER_OF_TASKS
$(error NUMBER_OF_TASKS is not set. Example, make push WORKFLOW_DIR=montage2-0.25 NUMBER_OF_TASKS=619)
endif

DATA_NAME ?= $(shell basename $(WORKFLOW_DIR))
PREFIX = hyperflowwms
REPO_NAME = montage2-workflow-data

# Linux and macos compatibility
MD5_COMMAND = $(shell type -p md5sum || type -p md5)
WORKFLOW_DIR_HASH = $(shell ls -l $(WORKFLOW_DIR) | $(MD5_COMMAND) | cut -d' ' -f1)
$(info MD5 of the workflow archive WORKFLOW_DIR_HASH=$(WORKFLOW_DIR_HASH))
BUILD_DATE = $(shell date +'%y.%m.%d' | $(MD5_COMMAND) )

NUMBER_OF_FILES=$(shell wc -l $(WORKFLOW_DIR) | cut -d' ' -f1)

DATA_LATEST = $(PREFIX)/$(REPO_NAME):$(DATA_NAME)-latest
DATA_TAG = $(PREFIX)/$(REPO_NAME):$(DATA_NAME)-$(WORKFLOW_DIR_HASH)

all: push

push: push-workflow-data
images: image-workflow-data 

image-workflow-data:
	echo "*" > .dockerignore
	echo "!$(WORKFLOW_DIR)" >> .dockerignore
	docker build --build-arg WORKFLOW_DIR=$(WORKFLOW_DIR) --build-arg WORKFLOW_DEGREE=$(WORKFLOW_DEGREE) --build-arg NUMBER_OF_TASKS=$(NUMBER_OF_TASKS) -t $(DATA_LATEST) . # Build new image and automatically tag it as latest
	docker tag $(DATA_LATEST) $(DATA_TAG)  # Add the version tag to the latest image

push-workflow-data: image-workflow-data
	docker push $(DATA_LATEST) # Push image tagged as latest to repository
	docker push $(DATA_TAG) # Push version tagged image to repository (since this image is already pushed it will simply create or update version tag)

clean:
	rm .dockerignore

