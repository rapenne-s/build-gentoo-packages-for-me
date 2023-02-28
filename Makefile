IMAGE_NAME ?= build-gentoo-packages-for-me
IMAGE_TAG ?= latest

all: build-image

build-image:
	docker build \
		-t $(IMAGE_NAME):$(IMAGE_TAG) \
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

copy-packages:
	rsync -av $(PWD)/packages github@maison.perso.pw:/

.PHONY: all build-image run-image run-shell copy-packages
