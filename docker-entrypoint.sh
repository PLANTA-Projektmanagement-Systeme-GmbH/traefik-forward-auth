#!/usr/bin/env sh

set -o errexit
set -o nounset

if [ "$1" = "traefik" ]; then
	# start forward-auth
	sh -c "${WORKDIR}/traefik-forward-auth & sleep 1"
	# start proxy
	exec "${WORKDIR}/traefik"
fi

# anything else
exec "$@"
