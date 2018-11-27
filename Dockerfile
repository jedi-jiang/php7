FROM php:alpine
LABEL maintainer="Nick Jiang <jedi.jiang97@gmail.com>"

# comment this to improve stability on "auto deploy" environments
RUN apk update && apk upgrade

# install basic dependencies
RUN apk -u add bash git

# install PHP extensions
ADD install-php7.sh /tmp/install-php7.sh
RUN /tmp/install-php7.sh

RUN mkdir -p /etc/ssl/certs && update-ca-certificates

WORKDIR /var/www
CMD ["/usr/local/bin/php"]
