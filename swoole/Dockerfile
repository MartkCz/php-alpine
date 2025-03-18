ARG ALPINE_VERSION=3.21

FROM alpine:${ALPINE_VERSION}

ARG PHP_VERSION
ARG SOURCE_DIR

ENV BUILD_PHP_VERSION="${PHP_VERSION}"
ENV BUILD_PHP_CUSTOM_INI="/etc/php${BUILD_PHP_VERSION}/conf.d/custom.ini"

# iconv fix
RUN apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/v3.13/community/ gnu-libiconv=1.15-r3
ENV LD_PRELOAD="/usr/lib/preloadable_libiconv.so php"

RUN apk add --no-cache \
    # Minimal libs
    "php$BUILD_PHP_VERSION" \
    "php$BUILD_PHP_VERSION-session" \
    "php$BUILD_PHP_VERSION-opcache" \
    "php$BUILD_PHP_VERSION-mbstring" \
    "php$BUILD_PHP_VERSION-tokenizer" \
    "php$BUILD_PHP_VERSION-sockets" \
    "php$BUILD_PHP_VERSION-pcntl" \
    "php$BUILD_PHP_VERSION-curl" \
    "php$BUILD_PHP_VERSION-xml" \
    "php$BUILD_PHP_VERSION-zip" \
    "php$BUILD_PHP_VERSION-ctype" \
    "php$BUILD_PHP_VERSION-dom" \
    "php$BUILD_PHP_VERSION-exif" \
    "php$BUILD_PHP_VERSION-bcmath" \
    "php$BUILD_PHP_VERSION-gmp" \
    "php$BUILD_PHP_VERSION-openssl" \
    "php$BUILD_PHP_VERSION-sodium" \
    "php$BUILD_PHP_VERSION-phar" \
    "php$BUILD_PHP_VERSION-pdo" \
    # Optional libs
    "php$BUILD_PHP_VERSION-pdo_mysql" \
    "php$BUILD_PHP_VERSION-pdo_sqlite" \
    "php$BUILD_PHP_VERSION-iconv" \
	"php$BUILD_PHP_VERSION-pecl-igbinary" \
    "php$BUILD_PHP_VERSION-redis" \
    "php$BUILD_PHP_VERSION-pecl-ds" \
    "php$BUILD_PHP_VERSION-intl" \
    "php$BUILD_PHP_VERSION-simplexml" \
    # Build specific libs
    "php$BUILD_PHP_VERSION-pecl-swoole"

COPY "$SOURCE_DIR/php.ini" "/etc/php$BUILD_PHP_VERSION/conf.d/custom.ini"
COPY --chmod=0755 "$SOURCE_DIR/entrypoint.sh" /

STOPSIGNAL SIGQUIT

WORKDIR /app

EXPOSE 8080/tcp

ENTRYPOINT ["/entrypoint.sh"]
CMD ["php", "public/index.php"]
