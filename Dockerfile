FROM php:7.1-cli

ENV http_proxy ${http_proxy}
ENV https_proxy ${http_proxy}

RUN apt-get update && apt-get install -y zip wget \
        libfreetype6-dev \
        libmcrypt-dev \
        git \
        libxslt-dev \
        libssh2-1-dev \
    && docker-php-ext-install -j$(nproc) zip

RUN cd /tmp && wget http://xdebug.org/files/xdebug-2.5.0.tgz && tar -xvzf xdebug-2.5.0.tgz \
    && cd xdebug-2.5.0 && phpize && ./configure && make && make install \
    && cp modules/xdebug.so /usr/local/lib/php/extensions/no-debug-non-zts-20160303 \
    && echo "zend_extension = /usr/local/lib/php/extensions/no-debug-non-zts-20160303/xdebug.so" > /usr/local/etc/php/conf.d/xdebug.ini \
&& echo "xdebug.var_display_max_depth=15" >> /usr/local/etc/php/conf.d/xdebug.ini

# Install ssh2
RUN wget https://pecl.php.net/get/ssh2-1.0.tgz \
    && tar vxzf ssh2-1.0.tgz \
    && cd ssh2-1.0 && phpize && ./configure --with-ssh2 \
    && make && make install \
    && echo "extension=ssh2.so" >> /usr/local/etc/php/conf.d/ssh2.ini

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer

RUN cd /tmp && wget https://phar.phpunit.de/phpunit.phar \
    && mv phpunit.phar /usr/bin/phpunit \
    && chmod a+x /usr/bin/phpunit

VOLUME ["/app"]
WORKDIR /app

ENTRYPOINT ["/usr/bin/phpunit"]
CMD ["--help"]