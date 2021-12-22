FROM alpine:3.15

ARG PHP_VERSION="8.0.13-r0"
ARG SWOOLE_VERSION="4.8.3"

# ensure www-data user exists
RUN set -eux; \
	adduser -u 82 -D -S -G www-data www-data
# 82 is the standard uid/gid for "www-data" in Alpine

## From https://github.com/docker-library/php/blob/master/8.0/alpine3.15/fpm/Dockerfile
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

## Iconv fix
RUN apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/v3.12/community/ --allow-untrusted gnu-libiconv=1.15-r2
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so

RUN apk --no-cache add php8=${PHP_VERSION} \
    curl \
    php8-ctype \
    php8-dev \
    php8-curl \
    php8-dom \
    php8-exif \
    php8-fileinfo \
    php8-fpm \
    php8-gd \
    php8-iconv \
    php8-intl \
    php8-mbstring \
    php8-mysqli \
    php8-opcache \
    php8-openssl \
    php8-pecl-imagick \
    php8-pecl-redis \
    php8-phar \
    php8-session \
    php8-simplexml \
    php8-soap \
    php8-xml \
    php8-xmlreader \
    php8-zip \
    php8-zlib \
    php8-bcmath \
    php8-pcntl \
    php8-sodium \
    php8-sockets \
    php8-pdo \
    php8-pdo_mysql \
    php8-xmlwriter \
    php8-tokenizer \
    ## Pecl
#    php8-pecl-imagick \
    php8-pecl-redis \
    ## Tools
    vim

# Symlink php8 => php
RUN ln -s /usr/bin/php8 /usr/bin/php
RUN ln -s /usr/sbin/php-fpm8 /usr/bin/php-fpm
RUN ln -s /usr/bin/phpize8 /usr/bin/phpize
RUN ln -s /usr/bin/php-config8 /usr/bin/php-config

## Composer
RUN curl -sfL https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer && \
        chmod +x /usr/bin/composer

## Swoole (only in edge)
RUN ( \
    mkdir /tmp/ext-swoole && \
    cd /tmp/ext-swoole && \
    apk add --no-cache libstdc++ && \
    apk add --no-cache --virtual .build-deps $PHPIZE_DEPS curl-dev openssl-dev pcre-dev pcre2-dev zlib-dev && \
    curl -sfL https://github.com/swoole/swoole-src/archive/v${SWOOLE_VERSION}.tar.gz -o /tmp/ext-swoole/swoole.tar.gz && \
    tar xfz swoole.tar.gz --strip-components=1 -C . && \
    phpize && \
    ./configure --enable-openssl --enable-sockets --enable-http2 --enable-swoole-json --enable-swoole-curl && \
    make && make install && \
    echo "extension=swoole" > /etc/php8/conf.d/00_swoole.ini && \
    apk del .build-deps && \
    rm -rf /tmp/ext-swoole \
    )

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
