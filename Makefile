IMAGE_REGISTRY ?= killruana
IMAGE_NAME ?= build-gentoo-packages-for-me
IMAGE_TAG ?= latest
CACHE_IMAGE_TAG ?= cache
PACKAGES ?= \
	app-portage/gentoolkit \
	app-text/tree

all: build-image

build-image:
	docker build \
		--cache-from type=registry,ref=$(IMAGE_REGISTRY)/$(IMAGE_NAME):$(CACHE_IMAGE_TAG) \
		-t $(IMAGE_REGISTRY)/$(IMAGE_NAME):$(IMAGE_TAG) \
		--build-arg PACKAGES="$(PACKAGES)" \
		.

build-image-load:
	docker build \
		--load \
		--cache-from type=registry,ref=$(IMAGE_REGISTRY)/$(IMAGE_NAME):$(CACHE_IMAGE_TAG) \
		-t $(IMAGE_REGISTRY)/$(IMAGE_NAME):$(IMAGE_TAG) \
		--build-arg PACKAGES="$(PACKAGES)" \
		.

build-image-push:
	docker buildx build \
		--push \
		--cache-to type=registry,ref=$(IMAGE_REGISTRY)/$(IMAGE_NAME):$(CACHE_IMAGE_TAG) \
		--cache-from type=registry,ref=$(IMAGE_REGISTRY)/$(IMAGE_NAME):$(CACHE_IMAGE_TAG) \
		--build-arg "PACKAGES=$(PACKAGES)" \
		-t $(IMAGE_REGISTRY)/$(IMAGE_NAME):$(IMAGE_TAG) .

run-image:
	docker run $(IMAGE_REGISTRY)/$(IMAGE_NAME):$(IMAGE_TAG)

run-shell:
	docker run -it $(IMAGE_REGISTRY)/$(IMAGE_NAME):$(IMAGE_TAG) bash

pull-image: 
	docker pull $(IMAGE_REGISTRY)/$(IMAGE_NAME):$(IMAGE_TAG)

push-image:
	docker push $(IMAGE_REGISTRY)/$(IMAGE_NAME):$(IMAGE_TAG)


.PHONY: all build-image build-image-load build-image-push run-image run-shell pull-image push-image