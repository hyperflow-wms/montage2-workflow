# Top-level Makefile for building all Montage workflow images
# This orchestrates building both base images and worker images for Montage 5.0 and 6.0

.PHONY: all help \
	build-all push-all \
	build-base-all push-base-all \
	build-base-5 push-base-5 \
	build-base-6 push-base-6 \
	build-worker-all push-worker-all \
	build-worker-5 push-worker-5 \
	build-worker-6 push-worker-6 \
	clean

# Default target
all: build-all

help:
	@echo "Montage Workflow Docker Images Build System"
	@echo ""
	@echo "Available targets:"
	@echo "  help              - Show this help message"
	@echo ""
	@echo "Build targets (local only):"
	@echo "  build-all         - Build all base and worker images"
	@echo "  build-base-all    - Build all base images (5.0 and 6.0)"
	@echo "  build-base-5      - Build Montage 5.0 base image"
	@echo "  build-base-6      - Build Montage 6.0 base image"
	@echo "  build-worker-all  - Build all worker images (5.0 and 6.0)"
	@echo "  build-worker-5    - Build Montage 5.0 worker image"
	@echo "  build-worker-6    - Build Montage 6.0 worker image"
	@echo ""
	@echo "Push targets (build and push to Docker Hub):"
	@echo "  push-all          - Build and push all images"
	@echo "  push-base-all     - Build and push all base images"
	@echo "  push-base-5       - Build and push Montage 5.0 base image"
	@echo "  push-base-6       - Build and push Montage 6.0 base image"
	@echo "  push-worker-all   - Build and push all worker images"
	@echo "  push-worker-5     - Build and push Montage 5.0 worker image"
	@echo "  push-worker-6     - Build and push Montage 6.0 worker image"
	@echo ""
	@echo "Other:"
	@echo "  clean             - Clean build artifacts"

# Build all images
build-all: build-base-all build-worker-all

# Push all images
push-all: push-base-all push-worker-all

# Base images targets
build-base-all: build-base-5 build-base-6

push-base-all: push-base-5 push-base-6

build-base-5:
	@echo "Building Montage 5.0 base image..."
	cd base-images/montage5 && $(MAKE) image

push-base-5:
	@echo "Building and pushing Montage 5.0 base image..."
	cd base-images/montage5 && $(MAKE) push

build-base-6:
	@echo "Building Montage 6.0 base image..."
	cd base-images/montage6 && $(MAKE) image

push-base-6:
	@echo "Building and pushing Montage 6.0 base image..."
	cd base-images/montage6 && $(MAKE) push

# Worker images targets
build-worker-all: build-worker-5 build-worker-6

push-worker-all: push-worker-5 push-worker-6

build-worker-5:
	@echo "Building Montage 5.0 worker image..."
	cd worker-images/montage5-worker && $(MAKE) image

push-worker-5:
	@echo "Building and pushing Montage 5.0 worker image..."
	cd worker-images/montage5-worker && $(MAKE) push

build-worker-6:
	@echo "Building Montage 6.0 worker image..."
	cd worker-images/montage6-worker && $(MAKE) image

push-worker-6:
	@echo "Building and pushing Montage 6.0 worker image..."
	cd worker-images/montage6-worker && $(MAKE) push

# Clean target
clean:
	@echo "Cleaning build artifacts..."
	cd base-images/montage5 && $(MAKE) clean
	cd base-images/montage6 && $(MAKE) clean
	cd worker-images/montage5-worker && $(MAKE) clean
	cd worker-images/montage6-worker && $(MAKE) clean
