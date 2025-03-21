# check=skip=InvalidDefaultArgInFrom
ARG BASE_IMAGE

FROM ${BASE_IMAGE}

RUN apk add --no-cache "php$BUILD_PHP_VERSION-pecl-swoole" "php$BUILD_PHP_VERSION-pecl-xdebug"
