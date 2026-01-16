#!/usr/bin/env sh

set -e

for script in /startup/*.sh; do
  if [ -f "$script" ]; then
    sh "$script"
  fi
done

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- frankenphp run "$@"
fi


exec "$@"
