IMAGE_NAME ?= build-gentoo-packages-for-me
IMAGE_TAG ?= latest

all: build-image

build-image:
	docker build \
		-t $(IMAGE_NAME):$(IMAGE_TAG) \
		.

run-image:
	# expire after 5h30 to export built packages before it's too late
	# we only have 6h00 of free time for a single build
	# 5h30 = 330 minutes
	timeout 330m docker run \
		-v $(PWD)/packages:/mnt/packages \
		$(IMAGE_NAME):$(IMAGE_TAG)

run-shell:
	docker run \
		-it \
		-v $(PWD)/packages:/mnt/packages \
		$(IMAGE_NAME):$(IMAGE_TAG) \
		sh

copy-packages:
	rsync -e "ssh -v -p 2222" -av $(PWD)/packages/ github@interbus.perso.pw:/var/www/gentoo-packages/

.PHONY: all build-image run-image run-shell copy-packages
