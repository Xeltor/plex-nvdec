FROM plexinc/pms-docker:plexpass

ADD https://raw.githubusercontent.com/revr3nd/plex-nvdec/master/plex-nvdec-patch.sh /etc/cont-init.d/60-plex-nvdec-patch
