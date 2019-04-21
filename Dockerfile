FROM php:5.6-apache
MAINTAINER SCL <scl@hanchih.com>

ENV APACHE_LOG_DIR /var/log/apache2
ENV PHALCON_TAG phalcon-v2.0.13

WORKDIR /phalcon
ADD https://github.com/phalcon/cphalcon/archive/$PHALCON_TAG.tar.gz ./phalcon.tar.gz

COPY apache.conf /etc/apache2/sites-enabled/000-default.conf

RUN a2enmod rewrite\
      && apt-get update\
      && apt-get -y install libpcre3-dev gcc make \
      && apt-get autoremove\
      && apt-get clean\
      && tar -xzf phalcon.tar.gz\
      && cd cphalcon-$PHALCON_TAG/build\
      && ./install\
      && rm -rf /phalcon\
      && echo 'extension=phalcon.so' | tee /usr/local/etc/php/conf.d/30-phalcon.ini\
      && echo '<?php phpinfo();' | tee /var/www/html/index.php

VOLUME ["/etc/apache2"]
VOLUME ["/usr/local/etc/php"]
VOLUME ["/var/www/html"]
VOLUME ["/var/log/apache2"]
