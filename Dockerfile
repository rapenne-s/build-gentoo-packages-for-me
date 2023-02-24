FROM gentoo/stage3:systemd AS build

# Get the latest portage tree
COPY --from=gentoo/portage:latest /var/db/repos/gentoo /var/db/repos/gentoo

# Configure the system
RUN emerge sys-apps/merge-usr
RUN merge-usr
RUN eselect profile set default/linux/amd64/17.1/systemd/merged-usr

# Import previously built packages
COPY --from=killruana/build-gentoo-packages-for-me /artifacts /var/cache/binpkgs

# Bootstrap
RUN if [ ! -f /var/cache/binpkgs/Packages ]; then emerge --quiet-build --buildpkg --with-bdeps=y --usepkg @installed; fi

# Rebuild the world
RUN emerge --quiet-build --buildpkg --with-bdeps=y --update --newuse --changed-use --usepkg @world

# Build asked packages
RUN emerge --quiet-build --buildpkg --with-bdeps=y --update --newuse --changed-use --usepkg app-portage/gentoolkit

FROM scratch AS artifacts
COPY --from=build /var/cache/binpkgs /artifacts