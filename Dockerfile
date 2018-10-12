FROM thomasredstone/base:3.0.0
# Install php-fpm
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -qq && apt-get -y upgrade

RUN apt-get install -y -qq software-properties-common language-pack-en-base curl
RUN apt-get install -y -qq libcurl3
RUN apt-get install -y -qq libcurl3-dev
RUN apt-get install -y -qq wget
RUN apt-get install -y -qq php7.2-fpm php7.2-mysql php7.2-curl php7.2-json php7.2-mbstring
RUN apt-get install -y -qq php7.2-zip php7.2-xml php7.2-sqlite php7.2-imap
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
exit $RESULT;

# Adding the configuration files
RUN mkdir /run/php/ && chown -R www-data:www-data /run/php/
ADD conf/www.conf /etc/php/7.2/fpm/pool.d/www.conf
ADD conf/php-fpm.conf /etc/php/7.2/fpm/php-fpm.conf
# Add the run script to run the service
ADD run.sh /run.sh

#add the volume for the application
VOLUME /var/www/app

# Expose the port 9000
EXPOSE 9000
# Run the run.sh script
ENTRYPOINT [ "/bin/bash", "/run.sh"]
