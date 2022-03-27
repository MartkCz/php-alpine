#!/usr/bin/env sh

BASEDIR=$(dirname "$0")

docker container run --rm -v "$(pwd)/$BASEDIR:/app/" "$1" "php iconv.php"

docker container run --rm -v "$(pwd)/$BASEDIR:/app/" "$1" 'echo $PHP_SUFFIX'

docker container run --rm --env "MKDIRS=/app/first /app/second" -v "$(pwd)/$BASEDIR:/app/" "$1" "ls"
