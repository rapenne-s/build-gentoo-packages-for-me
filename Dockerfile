##############################################################################
# Build image
#
# Build all our packages
##############################################################################
FROM gentoo/stage3:systemd AS build

# Get the latest portage tree
COPY --from=gentoo/portage:latest /var/db/repos/gentoo /var/db/repos/gentoo

# Copy our configuration
RUN rm -rf /etc/portage
COPY etc/portage /etc/portage
COPY etc/world /var/lib/portage/world

# Choose the profile
RUN eselect profile set default/linux/amd64/17.1/systemd/merged-usr

# Import previously built packages
COPY packages /var/cache/binpkgs

# Merge /usr
RUN emerge --quiet-build sys-apps/merge-usr
RUN merge-usr

RUN emerge --quiet-build -v sys-kernel/gentoo-sources
RUN eselect kernel set 1

# Build the packages
RUN emerge \
    --deep \
    --update \
    --newuse \
    --quiet-build \
    --changed-use \
    --with-bdeps=y \
    --usepkg \
    --buildpkg \
    @world \
    app-portage/gentoolkit

# Clean old packages
RUN eclean-pkg

CMD rsync \
    --archive \
    --delete \
    --verbose \
    /packages/ /mnt/packages/
