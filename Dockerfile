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

# Import previously built packages
COPY packages /var/cache/binpkgs

# Configure the system
RUN emerge \
    --deep \
    --update \
    --newuse \
    --changed-use \
    --with-bdeps=y \
    --usepkg \
    --buildpkg \
    --quiet-build \
    sys-apps/merge-usr
RUN merge-usr

# Choose the profile
RUN eselect profile set default/linux/amd64/17.1/systemd/merged-usr

# Build the packages
RUN emerge \
    --deep \
    --update \
    --newuse \
    --changed-use \
    --with-bdeps=y \
    --usepkg \
    --buildpkg \
    --quiet-build \
    @world \
    app-portage/gentoolkit

# Clean old packages
RUN eclean-pkg


##############################################################################
# Artifacts image
#
# Contains all the packages built in the previous image.
# We do that because the exported image is lighter than the build one
##############################################################################
FROM alpine
RUN apk add rsync

# Get the artifacts
COPY --from=build /var/cache/binpkgs /packages
COPY --from=build /var/lib/portage/world /packages/

# Export the artifacts
CMD rsync \
    --archive \
    --delete \
    --verbose \
    /packages/ /mnt/packages/