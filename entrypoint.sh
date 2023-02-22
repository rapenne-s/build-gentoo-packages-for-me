#!/bin/sh

# no docker image for merged-usr yet
emerge sys-apps/merge-usr
merge-usr
eselect profile set default/linux/amd64/17.1/systemd/merged-usr

# rebuild world
emerge -quDv --with-bdeps=y --changed-use --newuse @world

emerge -q app-portage/gentoolkit

# remove older stuff
eclean-pkg
