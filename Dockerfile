FROM thomasredstone/base:4.0.1
# Install php-fpm
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -qq && apt-get -y upgrade

RUN apt-get install -y -qq software-properties-common language-pack-en-base curl
RUN apt-get install -y -qq libcurl4
RUN apt-get install -y -qq wget
RUN apt-get install -y -qq php7.4-fpm php7.4-mysql php7.4-curl php7.4-json php7.4-mbstring
RUN apt-get install -y -qq php7.4-zip php7.4-xml php7.4-sqlite php7.4-imap php7.4-simplexml \
    php7.4-bcmath php7.4-gd php7.4-intl php7.4-pdo php7.4-common php-pear phpunit php7.4-dev \
    php7.4-soap libz-dev
RUN usermod -u 1000 www-data

#!/bin/sh

RUN EXPECTED_SIGNATURE="$(wget -q -O - https://composer.github.io/installer.sig)"; \
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"; \
ACTUAL_SIGNATURE="$(php -r "echo hash_file('SHA384', 'composer-setup.php');")"; \
if [ "$EXPECTED_SIGNATURE" != "$ACTUAL_SIGNATURE" ]; \
then \
    >&2 echo 'ERROR: Invalid installer signature'; \
    rm composer-setup.php; \
    exit 1; \
fi; \
php composer-setup.php --quiet; \
RESULT=$?; \
rm composer-setup.php; \
mv composer.phar /usr/local/bin/composer; \
chmod +x /usr/local/bin/composer; \
exit $RESULT;

RUN pecl install grpc
RUN pecl install protobuf
RUN echo extension=grpc.so >> /etc/php/7.4/cli/conf.d/20-grpc.ini
RUN echo extension=protobuf.so >> /etc/php/7.4/cli/conf.d/20-protobuf.ini
RUN echo extension=grpc.so >> /etc/php/7.4/fpm/conf.d/20-grpc.ini
RUN echo extension=protobuf.so >> /etc/php/7.4/fpm/conf.d/20-protobuf.ini

# Adding the configuration files
RUN mkdir /run/php/ && chown -R www-data:www-data /run/php/
ADD conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf
ADD conf/php-fpm.conf /etc/php/7.4/fpm/php-fpm.conf
# Add the run script to run the service
ADD run.sh /run.sh

# Expose the port 9000
EXPOSE 9000
# Run the run.sh script
ENTRYPOINT [ "/bin/bash", "/run.sh"]
