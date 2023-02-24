FROM gentoo/stage3:systemd AS build

# Get the latest portage tree
COPY --from=gentoo/portage:latest /var/db/repos/gentoo /var/db/repos/gentoo

# Configure the system
RUN emerge sys-apps/merge-usr
RUN merge-usr
RUN eselect profile set default/linux/amd64/17.1/systemd/merged-usr

# Import previously built packages
COPY packages /var/cache/binpkgs

# Bootstrap
RUN if [ ! -f /var/cache/binpkgs/Packages ]; then \
        emerge --quiet-build --buildpkg --with-bdeps=y --usepkg @installed; \
    fi

# Rebuild the world
RUN emerge --quiet-build --buildpkg --with-bdeps=y --update --newuse --changed-use --usepkg @world

# Build asked packages
ARG PACKAGES=
RUN if [ "x${PACKAGES}" != "x" ]; then \
        emerge --quiet-build --buildpkg --with-bdeps=y --update --newuse --changed-use --usepkg ${PACKAGES}; \
    fi


FROM alpine
RUN apk add rsync
COPY --from=build /var/cache/binpkgs /packages
CMD rsync -avPh /packages/ /mnt/packages/