FROM php:7.1-cli

ENV http_proxy ${http_proxy}
ENV https_proxy ${http_proxy}

RUN apt-get update && apt-get install -y zip \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
        git \
        libxslt-dev \
        wget \
        sqlite3 \
        libsqlite3-dev

RUN docker-php-ext-install -j$(nproc) iconv mcrypt zip soap pdo_mysql bcmath pdo_sqlite
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/
RUN docker-php-ext-install -j$(nproc) gd

# Install xDebug
RUN cd /tmp && wget http://xdebug.org/files/xdebug-2.5.0.tgz && tar -xvzf xdebug-2.5.0.tgz \
    && cd xdebug-2.5.0 && phpize && ./configure && make && make install \
    && cp modules/xdebug.so /usr/local/lib/php/extensions/no-debug-non-zts-20160303 \
    && echo "zend_extension = /usr/local/lib/php/extensions/no-debug-non-zts-20160303/xdebug.so" > /usr/local/etc/php/conf.d/xdebug.ini \
&& echo "xdebug.var_display_max_depth=15" >> /usr/local/etc/php/conf.d/xdebug.ini

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer

VOLUME ["/app"]
WORKDIR /app