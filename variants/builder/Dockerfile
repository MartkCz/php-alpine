ARG php_version=8.5

FROM php:${php_version}-zts-alpine3.23

ARG php_version

# Core (opcache, bcmath, exif, gmp, intl, zip, sockets, pdo_mysql, gd, pcntl)
# Note: opcache is built-in since PHP 8.5
RUN apk add --no-cache --virtual .build-deps gmp-dev icu-dev libzip-dev libpng-dev libwebp-dev libjpeg-turbo-dev freetype-dev libavif-dev linux-headers \
    && if [ "$(printf '%s\n' "8.5" "$php_version" | sort -V | head -n1)" != "8.5" ]; then \
         docker-php-ext-configure opcache --enable-opcache && docker-php-ext-install -j$(nproc) opcache; \
       fi \
    && docker-php-ext-configure bcmath --enable-bcmath && docker-php-ext-install -j$(nproc) bcmath \
    && docker-php-ext-configure exif --enable-exif && docker-php-ext-install -j$(nproc) exif \
    && docker-php-ext-configure gmp --with-gmp && docker-php-ext-install -j$(nproc) gmp \
    && docker-php-ext-configure intl --enable-intl && docker-php-ext-install -j$(nproc) intl \
    && docker-php-ext-configure zip --with-zip && docker-php-ext-install -j$(nproc) zip \
    && docker-php-ext-configure sockets --enable-sockets && docker-php-ext-install -j$(nproc) sockets \
    && docker-php-ext-configure pdo_mysql --with-pdo-mysql && docker-php-ext-install -j$(nproc) pdo_mysql \
    && docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg --with-webp --with-avif && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-configure pcntl --enable-pcntl && docker-php-ext-install -j$(nproc) pcntl \
    && apk del --no-network .build-deps

# Pecl (brotli, ds, igbinary, redis, xdebug, uopz)
# util-linux-dev for uuid (from edge, requires sqlite-libs upgrade due to version mismatch)
#RUN apk add --no-cache sqlite-libs util-linux-dev --repository=http://dl-cdn.alpinelinux.org/alpine/edge/main --allow-untrusted
RUN apk add --no-cache --virtual .build-deps $PHPIZE_DEPS linux-headers brotli-dev util-linux-dev \
    && pecl install brotli-0.18.3 && docker-php-ext-enable brotli \
    && pecl install ds-1.6.0 && docker-php-ext-enable ds \
    && pecl install igbinary-3.2.17RC1 && docker-php-ext-enable igbinary \
    && pecl install redis-6.3.0 && docker-php-ext-enable redis \
    && pecl install xdebug-3.5.0 && docker-php-ext-enable xdebug \
    && apk del --no-network .build-deps
#RUN apk del --no-network util-linux-dev

COPY source/10_xdebug.ini /usr/local/etc/php/conf.d/

# Rename all docker-php-ext-*.ini files to 00_*.ini
RUN for file in /usr/local/etc/php/conf.d/docker-php-ext-*.ini; do \
      target="00_$(echo "$(basename "$file")" | sed -e 's/docker-php-ext-\(.*\)\.ini/\1/').ini"; \
      mv "$file" "/usr/local/etc/php/conf.d/$target"; \
    done

RUN cp /usr/local/etc/php/php.ini-development /usr/local/etc/php/php.ini
