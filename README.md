# build-gentoo-packages-for-me

Declare your needed [packages](etc/world) and let Github Actions builds and exports all your precious binary packages for fasta updates of your low-power gentoo boxes.

# How to use it

Create a file `/etc/portage/binrepos.conf` with the following content:

```
[github-is-doing-the-job]
priority = 9999
sync-uri = https://interbus.perso.pw/
```
