#!/usr/bin/env sh

DIRNAME=$(dirname "$0")

if [ -z "$1" ]; then
    echo "Usage: $0 <image>"
    exit 1
fi

docker run --rm -v "$DIRNAME:/mnt" -w /mnt "$1" time php benchmark.php
