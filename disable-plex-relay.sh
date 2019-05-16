#!/usr/bin/with-contenv bash

if ! [ -z "$DISABLE_PLEX_RELAY" ]; then
	rm -f "/usr/lib/plexmediaserver/Plex Relay"
	echo "Removed Plex Relay."
fi
