ARG php_version=8.5

FROM ghcr.io/roadrunner-server/roadrunner:2025.1.6 AS roadrunner
FROM martkcz/php-alpine:${php_version}-builder AS build
FROM alpine:3.23

ENV BUILD_HOME=/app
ENV BUILD_STARTUP=/startup
ENV XDEBUG_MODE=off

RUN mkdir /startup

# Runtime
RUN apk add --no-cache \
		gmp \
		go-task \
        icu icu-libs \
        libzip \
        brotli \
        libuuid \
        libpng libavif libwebp libjpeg-turbo freetype

# Custom libraries
RUN apk add --no-cache \
        patch

ENV BUILD_PHP_CUSTOM_INI="/usr/local/etc/php/conf.d/99_custom.ini"
ENV BUILD_PHP_CUSTOM_INI_DIR="/usr/local/etc/php/conf.d"
ENV PHP_INI_DIR="/usr/local/etc/php"
ENV PHP_CUSTOM_INI_DIR="/usr/local/etc/php/conf.d"
ENV PHP_CUSTOM_INI="/usr/local/etc/php/conf.d/99_custom.ini"
ENV DOCKER_CONTAINER="1"

COPY --from=build /usr/local/bin/php /usr/local/bin/php
COPY --from=build /usr/local/lib/php /usr/local/lib/php
COPY --from=build /usr/lib /usr/lib
COPY --from=build /usr/local/etc/php /usr/local/etc/php
COPY --from=build "$PHP_INI_DIR" "$PHP_INI_DIR"

COPY --from=composer/composer:latest-bin /composer /usr/bin/composer

COPY source/bin/ /usr/local/bin/
COPY source/10_enable-opcache.ini "$PHP_CUSTOM_INI_DIR/"
COPY --chmod=0755 source/entrypoint.sh /

# Custom
COPY --from=roadrunner /usr/bin/rr /usr/local/bin/rr
# / Custom

WORKDIR /app

STOPSIGNAL SIGTERM

ENTRYPOINT ["/entrypoint.sh"]

CMD ["php"]
