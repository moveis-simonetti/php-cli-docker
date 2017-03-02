FROM php:5.5-cli

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
        libsqlite3-dev \
        libssl-dev

RUN [ "" != "$http_proxy" ] && pear config-set http_proxy $http_proxy

# Install SSH2
RuN cd /tmp && wget https://www.libssh2.org/download/libssh2-1.8.0.tar.gz \
    && tar -zxvf libssh2-1.8.0.tar.gz && cd libssh2-1.8.0 \
    && ./configure && make && make install \
    && pecl install ssh2-0.13

RUN docker-php-ext-install -j$(nproc) iconv mcrypt zip soap pdo_mysql bcmath pdo_sqlite
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/
RUN docker-php-ext-install -j$(nproc) gd


# Install xDebug
RUN pecl install xdebug \
    && echo "xdebug.var_display_max_depth=15" >> /usr/local/etc/php/conf.d/xdebug.ini

RUN docker-php-ext-enable xdebug ssh2

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer

VOLUME ["/app"]
WORKDIR /app
