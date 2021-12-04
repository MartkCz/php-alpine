# PHP-8.0.13 alpine 

PHP 8 with composer

## Production
```dockerfile
# PHP
USER root

RUN cp /examples/php/99_production.ini /etc/php8/conf.d/ && \
    rm /etc/php8/conf.d/98_development.ini
    
## PHP-fpm    
RUN cp /examples/php-fpm/www-production.ini /etc/php8/fpm-conf.d/www.ini

USER www-data
```

## Swoole uninstall

```dockerfile
USER root

RUN rm /usr/lib/php8/modules/swoole.so && \
    rm /etc/php8/conf.d/00_swoole.ini
    
USER www-data
```
