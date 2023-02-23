IMAGE_REPOSITORY ?= killruana
IMAGE_NAME ?= build-gentoo-packages-for-me
IMAGE_TAG ?= latest

all: build-image

build-image:
	docker build -t $(IMAGE_REPOSITORY)/$(IMAGE_NAME):$(IMAGE_TAG) .

run-image:
	docker run $(IMAGE_REPOSITORY)/$(IMAGE_NAME):$(IMAGE_TAG)

run-image-shell:
	docker run -it $(IMAGE_REPOSITORY)/$(IMAGE_NAME):$(IMAGE_TAG) bash

push-image:
	docker push $(IMAGE_REPOSITORY)/$(IMAGE_NAME):$(IMAGE_TAG)


.PHONY: all build-image run-image run-image-shell