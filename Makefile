IMAGE_NAME ?= gentoo-build-package
IMAGE_TAG ?= latest

all: build-image

build-image:
	docker build -t $(IMAGE_NAME)/$(IMAGE_TAG) .

run-image: build-image
	docker run $(IMAGE_NAME)/$(IMAGE_TAG)

run-image-shell: build-image
	docker run -it $(IMAGE_NAME)/$(IMAGE_TAG) bash


.PHONY: all build-image run-image run-image-shell