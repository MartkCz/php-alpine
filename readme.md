# PHP-8.0.14 alpine 

https://hub.docker.com/repository/docker/martkcz/php-alpine

PHP 8 with composer

## Production
```dockerfile

USER root

# PHP
RUN cp /production/php/99_settings.ini /etc/php8/conf.d/
    
# PHP-fpm    
RUN cp /production/php-fpm/www.conf /etc/php8/php-fpm.d/

USER www-data
```

## Swoole uninstall

```dockerfile
USER root

# Remove swoole
RUN rm /usr/lib/php8/modules/swoole.so && rm /etc/php8/conf.d/00_swoole.ini
    
USER www-data
```
