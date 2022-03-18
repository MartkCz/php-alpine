FROM alpine:3.15

ARG PHP_VERSION="8.1.3-r1"

# ensure www-data user exists
RUN set -eux; \
	adduser -u 82 -D -S -G www-data www-data
# 82 is the standard uid/gid for "www-data" in Alpine

## From https://github.com/docker-library/php/blob/master/8.1/alpine3.15/fpm/Dockerfile
ENV PHPIZE_DEPS \
		autoconf \
		dpkg-dev dpkg \
		file \
		g++ \
		gcc \
		libc-dev \
		make \
		pkgconf \
		re2c

# Iconv fix
RUN apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/v3.12/community/ --allow-untrusted gnu-libiconv=1.15-r2
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so

RUN apk --no-cache --repository https://dl-cdn.alpinelinux.org/alpine/edge/main add \
    icu-libs \
    && apk --no-cache --repository https://dl-cdn.alpinelinux.org/alpine/edge/community add \
    # Current packages don't exist in other repositories
    libavif \
    && apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing/ --allow-untrusted gnu-libiconv \
    # Packages \
    curl \
    php81 \
    php81-dev \
    php81-common \
    php81-gd \
    php81-xmlreader \
    php81-fileinfo \
    php81-bcmath \
    php81-ctype \
    php81-curl \
    php81-exif \
    php81-iconv \
    php81-intl \
    php81-mbstring \
    php81-opcache \
    php81-openssl \
    php81-pcntl \
    php81-phar \
    php81-session \
    php81-xml \
    php81-xsl \
    php81-zip \
    php81-zlib \
    php81-dom \
    php81-fpm \
    php81-sodium \
    php81-pecl-imagick \
    php81-pecl-redis \
    php81-simplexml \
    php81-sockets \
    php81-pdo \
    php81-pdo_mysql \
    php81-tokenizer \
    php81-soap \
    # Iconv Fix
    php81-pecl-apcu \
    # Tools
    vim

# Symlink php81 => php
RUN ln -s /usr/bin/php81 /usr/bin/php
RUN ln -s /usr/sbin/php-fpm81 /usr/bin/php-fpm
RUN ln -s /usr/bin/phpize81 /usr/bin/phpize
RUN ln -s /usr/bin/php-config81 /usr/bin/php-config

## Composer
RUN curl -sfL https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer && \
        chmod +x /usr/bin/composer

COPY conf/php/99_settings.ini /etc/php8/conf.d/
COPY conf/php/99_production.ini /production/php/99_settings.ini

COPY conf/php-fpm/php-fpm.conf /etc/php8/
COPY conf/php-fpm/www.conf /etc/php8/php-fpm.d/
COPY conf/php-fpm/www-production.conf /production/php-fpm/www.conf

RUN mkdir -p /app/www && mkdir /.composer

RUN chown -R www-data.www-data /app && \
    chown -R www-data.www-data /run && \
    chown -R www-data.www-data /var/log && \
    chown -R www-data.www-data /.composer

WORKDIR /app

# Switch to use a non-root user from here on
USER www-data

CMD ["php", "-a"]
