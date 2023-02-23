FROM gentoo/stage3:systemd AS build

# Get the latest portage tree
COPY --from=gentoo/portage:latest /var/db/repos/gentoo /var/db/repos/gentoo

# Configune the system
RUN emerge sys-apps/merge-usr
RUN merge-usr
RUN eselect profile set default/linux/amd64/17.1/systemd/merged-usr

# Rebuild the world
RUN emerge --quiet-build --buildpkg --with-bdeps=y @installed
RUN emerge --quiet-build --buildpkg --with-bdeps=y app-portage/gentoolkit

#COPY entrypoint.sh /bin/entrypoint
#ENTRYPOINT ["/bin/entrypoint", "--"]
#CMD rsync -av /var/cache/binpkgs/ /mnt

FROM gentoo/stage3:systemd AS artifacts
COPY --from=build /var/cache/binpkgs /artifacts