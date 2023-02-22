FROM gentoo/portage:latest as portage
FROM gentoo/stage3:systemd

COPY --from=portage /var/db/repos/gentoo /var/db/repos/gentoo

ADD ./entrypoint.sh /

CMD [ "bash", "./entrypoint.sh" ]
