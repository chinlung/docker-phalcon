FROM php:5.6-apache
MAINTAINER SCL <scl@hanchih.com>

ENV APACHE_LOG_DIR /var/log/apache2
ENV PHALCON_TAG phalcon-v1.3.4

WORKDIR /phalcon
ADD https://github.com/phalcon/cphalcon/archive/$PHALCON_TAG.tar.gz ./phalcon.tar.gz

COPY apache.conf /etc/apache2/sites-enabled/000-default.conf

# Phalcon's optional dependencies
RUN apt-get update && \
    apt-get install -y libmcrypt-dev \
    libpq-dev \
    libssl-dev \
    libpng-dev \
    libwebp-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    libxpm-dev 

RUN apt-get clean

RUN docker-php-ext-configure gd \
    --with-gd \
    --with-jpeg-dir \
    --with-png-dir \
    --with-zlib-dir \
    --with-xpm-dir \
    --with-freetype-dir \
    --enable-gd-native-ttf

RUN docker-php-ext-install mbstring mcrypt pdo_mysql pdo_pgsql gd

# docker-php-ext-install phalcon doesn't work
RUN apt-get install -y gcc libpcre3-dev make git 
RUN apt-get clean
RUN tar -xzf phalcon.tar.gz
RUN cd cphalcon-$PHALCON_TAG/build && ./install
RUN echo 'extension=phalcon.so' > /usr/local/etc/php/conf.d/phalcon.ini
RUN echo '<?php phpinfo();' > /var/www/html/index.php
RUN rm -fr /phalcon

# We uses .htaccess
RUN a2enmod rewrite

# Composer install depends on Phalcon version
RUN docker-php-ext-install pcntl zip 
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN composer global require --dev 'phalcon/devtools:1.3.x-dev'
RUN ln -s ~/.composer/vendor/bin/phalcon.php /usr/bin/phalcon
RUN chmod ugo+x /usr/bin/phalcon

RUN apt-get install -y time

VOLUME ["/etc/apache2"]
VOLUME ["/usr/local/etc/php"]
VOLUME ["/var/www/html"]
VOLUME ["/var/log/apache2"]