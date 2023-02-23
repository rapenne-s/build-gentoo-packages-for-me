FROM gentoo/stage3:systemd AS build

# Get the latest portage tree
COPY --from=gentoo/portage:latest /var/db/repos/gentoo /var/db/repos/gentoo

# Configune the system
RUN emerge sys-apps/merge-usr
RUN merge-usr
RUN eselect profile set default/linux/amd64/17.1/systemd/merged-usr

# Rebuild the world
RUN emerge -quDv --with-bdeps=y --changed-use --newuse @world
RUN emerge -q app-portage/gentoolkit
RUN eclean-pkg