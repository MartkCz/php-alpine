ARG php_version=8.5

FROM dunglas/frankenphp:1.9.1-php${php_version}-alpine

ENV BUILD_HOME=/app
ENV BUILD_STARTUP=/startup
ENV XDEBUG_MODE=off

RUN mkdir /startup

# PHP extensions
RUN install-php-extensions opcache bcmath exif gmp intl zip sockets pdo_mysql gd pcntl \
    uuid brotli ds igbinary redis \
    @composer

# Custom libraries
RUN apk add --no-cache \
        patch

# deprecated
ENV BUILD_PHP_CUSTOM_INI="/usr/local/etc/php/conf.d/99_custom.ini"
ENV BUILD_PHP_CUSTOM_INI_DIR="/usr/local/etc/php/conf.d"

ENV CADDYFILE_PATH="/etc/frankenphp/Caddyfile"
ENV PHP_INI_DIR="/usr/local/etc/php"
ENV PHP_CUSTOM_INI_DIR="/usr/local/etc/php/conf.d"
ENV PHP_CUSTOM_INI="/usr/local/etc/php/conf.d/99_custom.ini"
ENV DOCKER_CONTAINER="1"

COPY source/bin/ /usr/local/bin/
COPY source/10_enable-opcache.ini "$PHP_CUSTOM_INI_DIR/"
COPY source/10_xdebug.ini "$PHP_CUSTOM_INI_DIR/"
COPY --chmod=0755 source/entrypoint-franken.sh /entrypoint.sh
COPY source/caddy/Caddyfile "$CADDYFILE_PATH"

# Rename all docker-php-ext-*.ini files to 00_*.ini
RUN for file in /usr/local/etc/php/conf.d/docker-php-ext-*.ini; do \
      target="00_$(echo "$(basename "$file")" | sed -e 's/docker-php-ext-\(.*\)\.ini/\1/').ini"; \
      mv "$file" "/usr/local/etc/php/conf.d/$target"; \
    done

RUN cp "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"
RUN mkdir -p /data/caddy/pki/authorities/local/ --mode 777
RUN chmod 777 -R /config/caddy
RUN chmod 777 -R /data/caddy

WORKDIR /app
ENTRYPOINT ["/entrypoint.sh"]
