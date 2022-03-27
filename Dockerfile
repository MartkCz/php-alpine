FROM alpine:3.15

ARG PHP

# ensure www-data user exists
RUN set -eux; \
	adduser -u 82 -D -S -G www-data www-data
# 82 is the standard uid/gid for "www-data" in Alpine

ENV PHP_SUFFIX="$PHP"

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
    php$PHP_SUFFIX \
    php$PHP_SUFFIX-dev \
    php$PHP_SUFFIX-common \
    php$PHP_SUFFIX-gd \
    php$PHP_SUFFIX-xmlreader \
    php$PHP_SUFFIX-fileinfo \
    php$PHP_SUFFIX-bcmath \
    php$PHP_SUFFIX-ctype \
    php$PHP_SUFFIX-curl \
    php$PHP_SUFFIX-exif \
    php$PHP_SUFFIX-iconv \
    php$PHP_SUFFIX-intl \
    php$PHP_SUFFIX-mbstring \
    php$PHP_SUFFIX-opcache \
    php$PHP_SUFFIX-openssl \
    php$PHP_SUFFIX-pcntl \
    php$PHP_SUFFIX-phar \
    php$PHP_SUFFIX-session \
    php$PHP_SUFFIX-xml \
    php$PHP_SUFFIX-xsl \
    php$PHP_SUFFIX-zip \
    php$PHP_SUFFIX-zlib \
    php$PHP_SUFFIX-dom \
    php$PHP_SUFFIX-fpm \
    php$PHP_SUFFIX-sodium \
    php$PHP_SUFFIX-pecl-imagick \
    php$PHP_SUFFIX-pecl-redis \
    php$PHP_SUFFIX-simplexml \
    php$PHP_SUFFIX-sockets \
    php$PHP_SUFFIX-pdo \
    php$PHP_SUFFIX-pdo_mysql \
    php$PHP_SUFFIX-tokenizer \
    php$PHP_SUFFIX-soap \
    # Iconv Fix
    php$PHP_SUFFIX-pecl-apcu \
    # Tools
    vim

# Symlink php81 => php
RUN ln -s /usr/bin/php$PHP_SUFFIX /usr/bin/php
RUN ln -s /usr/sbin/php-fpm$PHP_SUFFIX /usr/bin/php-fpm
RUN ln -s /usr/bin/phpize$PHP_SUFFIX /usr/bin/phpize
RUN ln -s /usr/bin/php-config$PHP_SUFFIX /usr/bin/php-config

## Composer
RUN curl -sfL https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer && \
        chmod +x /usr/bin/composer

# Configs php
COPY conf/php/99_settings.dev.ini /etc/php$PHP_SUFFIX/conf.d/99_settings.ini

# Configs php production
COPY conf/php/99_settings.prod.ini /prod/php/99_settings.ini

# Configs php-fpm
COPY conf/php-fpm/php-fpm.conf /etc/php$PHP_SUFFIX/
COPY conf/php-fpm/www.dev.conf /etc/php$PHP_SUFFIX/php-fpm.d/www.conf

# Configs php-fpm production
COPY conf/php-fpm/www.prod.conf /prod/php-fpm/www.conf

RUN mkdir -p /app/www && mkdir /.composer

RUN chown -R www-data.www-data /app && \
    chown -R www-data.www-data /run && \
    chown -R www-data.www-data /var/log && \
    chown -R www-data.www-data /.composer

WORKDIR /app

# Switch to use a non-root user from here on
USER www-data

COPY entrypoint /entrypoint

ENTRYPOINT ["/entrypoint"]

CMD ["/usr/bin/php-fpm", "-R", "--nodaemonize"]
