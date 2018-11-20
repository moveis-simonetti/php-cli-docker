FROM php:7.0-cli

ENV http_proxy ${http_proxy}
ENV https_proxy ${http_proxy}

RUN apt-get update && apt-get install -y zip \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
        git \
        libxslt-dev \
        wget \
        sqlite3 \
        libsqlite3-dev \
        libicu-dev

RUN docker-php-ext-install -j$(nproc) iconv mcrypt zip soap pdo_mysql bcmath pdo_sqlite intl sockets && \
    docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ && \
    docker-php-ext-install -j$(nproc) gd

# Install xDebug
RUN cd /tmp && wget http://xdebug.org/files/xdebug-2.5.5.tgz && tar -xvzf xdebug-2.5.5.tgz \
    && cd xdebug-2.5.5 && phpize && ./configure && make && make install \
    && mkdir -p /usr/local/lib/php/extensions/no-debug-non-zts-20171005 \
    && cp modules/xdebug.so /usr/local/lib/php/extensions/no-debug-non-zts-20171005 \
    && echo "zend_extension = /usr/local/lib/php/extensions/no-debug-non-zts-20171005/xdebug.so" > /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.var_display_max_depth=15" >> /usr/local/etc/php/conf.d/xdebug.ini

RUN echo "Install Redis" \
    && pecl install "redis-3.1.1" && docker-php-ext-enable redis

RUN echo "Install ssh2" \
    && apt-get install -y libssh2-1-dev libssh2-1 \
    && wget https://www.libssh2.org/download/libssh2-1.7.0.tar.gz && wget http://pecl.php.net/get/ssh2-1.0.tgz \
    && tar vxzf libssh2-1.7.0.tar.gz && tar vxzf ssh2-1.0.tgz \
    && cd libssh2-1.7.0 && ./configure \
    && make && make install \
    && cd ../ssh2-1.0 && phpize && ./configure --with-ssh2 \
    && make && make install \
    && echo "extension=ssh2.so" >> /usr/local/etc/php/conf.d/ssh2.ini

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer

VOLUME ["/app"]
WORKDIR /app
