#!/bin/sh
set -ex

: "${SOCKS_USERNAME:?Need to set SOCKS_USERNAME non-empty}"
: "${SOCKS_PASSWORD:?Need to set SOCKS_PASSWORD non-empty}"

# do not recreate user if it exists
user_exists=$(id -u $SOCKS_USERNAME > /dev/null 2>&1; echo $?)
if [ $user_exists -eq 1 ]; then
	adduser -D -H -s /bin/false $SOCKS_USERNAME
fi

# force password to what was set
echo "$SOCKS_USERNAME:$SOCKS_PASSWORD" | chpasswd

# first arg is `-f` or `--some-option`
# or first arg is `something.conf`
if [ "${1#-}" != "$1" ] || [ "${1%.conf}" != "$1" ]; then
	set -- sockd "$@"
fi

# allow the container to be started with `--user`
if [ "$1" = 'sockd' -a "$(id -u)" = '0' ]; then
	exec su-exec sockd "$@"
fi

exec "$@"
