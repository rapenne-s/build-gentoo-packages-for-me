##############################################################################
# Build image
#
# Build all our packages
##############################################################################
FROM gentoo/stage3:systemd AS build

# Get the latest portage tree
COPY --from=gentoo/portage:latest /var/db/repos/gentoo /var/db/repos/gentoo

# Copy our configuration
COPY etc/portage /etc/portage
COPY etc/world /var/lib/portage/world

# Configure the system
RUN emerge --quiet-build --buildpkg --with-bdeps=y --usepkg sys-apps/merge-usr
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


##############################################################################
# Artifacts image
#
# Contains all the packages built in the previous image
##############################################################################
FROM alpine
RUN apk add rsync
COPY --from=build /var/cache/binpkgs /packages
COPY --from=build /var/lib/portage/world /packages/
CMD rsync -avPh /packages/ /mnt/packages/