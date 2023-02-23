IMAGE_REGISTRY ?= killruana
IMAGE_NAME ?= build-gentoo-packages-for-me
IMAGE_TAG ?= latest
CACHE_IMAGE_TAG ?= cache

all: build-image

build-image:
	docker build -t $(IMAGE_REGISTRY)/$(IMAGE_NAME):$(IMAGE_TAG) .

build-image-with-cache:
	docker buildx build \
		--cache-to type=registry,ref=$(IMAGE_REGISTRY)/$(IMAGE_NAME):$(CACHE_IMAGE_TAG) \
		--cache-from type=registry,ref=$(IMAGE_REGISTRY)/$(IMAGE_NAME):$(CACHE_IMAGE_TAG) \
		-t $(IMAGE_REGISTRY)/$(IMAGE_NAME):$(IMAGE_TAG) .

build-image-with-cache-and-push:
	docker buildx build \
		--push \
		--cache-to type=registry,ref=$(IMAGE_REGISTRY)/$(IMAGE_NAME):$(CACHE_IMAGE_TAG) \
		--cache-from type=registry,ref=$(IMAGE_REGISTRY)/$(IMAGE_NAME):$(CACHE_IMAGE_TAG) \
		-t $(IMAGE_REGISTRY)/$(IMAGE_NAME):$(IMAGE_TAG) .

run-image:
	docker run $(IMAGE_REGISTRY)/$(IMAGE_NAME):$(IMAGE_TAG)

run-image-shell:
	docker run -it $(IMAGE_REGISTRY)/$(IMAGE_NAME):$(IMAGE_TAG) bash

pull-image: 
	docker pull $(IMAGE_REGISTRY)/$(IMAGE_NAME):$(IMAGE_TAG)

push-image:
	docker push $(IMAGE_REGISTRY)/$(IMAGE_NAME):$(IMAGE_TAG)


.PHONY: all build-image build-image-with-cache build-image-with-cache-and-push run-image run-image-shell pull-image push-image