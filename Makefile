IMAGE_NAME ?= build-gentoo-packages-for-me
IMAGE_TAG ?= latest

PACKAGES ?= \
	app-portage/gentoolkit \
	app-text/tree

all: build-image

build-image:
	docker build \
		-t $(IMAGE_NAME):$(IMAGE_TAG) \
		--build-arg PACKAGES="$(PACKAGES)" \
		.

run-image:
	docker run \
		-v $(PWD)/packages:/mnt/packages \
		$(IMAGE_NAME):$(IMAGE_TAG)

run-shell:
	docker run \
		-it \
		-v $(PWD)/packages:/mnt/packages \
		$(IMAGE_NAME):$(IMAGE_TAG) \
		sh

.PHONY: all build-image run-image run-shell