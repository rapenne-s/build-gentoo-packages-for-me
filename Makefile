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

load-packages:
	rsync -e "ssh -v -p 2222" -av github@interbus.perso.pw:/var/www/gentoo-packages/ $(PWD)/packages/

copy-packages:
	rsync -e "ssh -v -p 2222" -av $(PWD)/packages/ github@interbus.perso.pw:/var/www/gentoo-packages/

.PHONY: all build-image run-image run-shell copy-packages
