#!/bin/sh

LIBS="file \
  re2c \
  freetds \
  freetype \
  icu \
  libintl \
  libldap \
  libjpeg \
  libmcrypt \
  libpng \
  libpq \
  libwebp"
apk add $LIBS

DEVLIBS="autoconf \
  curl-dev \
  freetds-dev \
  freetype-dev \
  g++ \
  gcc \
  gettext-dev \
  icu-dev \
  jpeg-dev \
  libmcrypt-dev \
  libpng-dev \
  libwebp-dev \
  libxml2-dev \
  make \
  openldap-dev"
apk add $DEVLIBS

# configure extensions
docker-php-ext-configure gd --with-jpeg-dir=usr/ --with-freetype-dir=usr/ --with-webp-dir=usr/
docker-php-ext-configure ldap --with-libdir=lib/
docker-php-ext-configure pdo_dblib --with-libdir=lib/

# install mongo extension
cd /tmp && \
  git clone https://github.com/mongodb/mongo-php-driver.git && \
  cd mongo-php-driver && \
  git submodule update --init && \
  phpize && \
  ./configure --with-mongodb-ssl=libressl && \
  make all && \
  make install && \
  echo "extension=mongodb.so" > /usr/local/etc/php/conf.d/mongodb.ini && \
  rm -rf /tmp/mongo-php-driver

docker-php-ext-install \
  curl \
  exif \
  gd \
  gettext \
  intl \
  ldap \
  pdo_dblib \
  pdo_mysql \
  pdo_pgsql \
  xmlrpc \
  zip

# download trusted certs
mkdir -p /etc/ssl/certs && update-ca-certificates

# install composer
cd /tmp && php -r "readfile('https://getcomposer.org/installer');" | php && \
  mv composer.phar /usr/bin/composer && \
  chmod +x /usr/bin/composer

apk del $DEVLIBS

