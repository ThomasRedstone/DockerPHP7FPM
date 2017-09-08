FROM thomasredstone/base:2.0.1
# Install php-fpm
RUN apt-get update -qq && apt-get -y upgrade
RUN apt-get install -y -qq software-properties-common

RUN apt-get update && apt-get -y -qq install curl libcurl3 libcurl3-dev php7.0-fpm php7.0-mysql php7.0-curl php7.0-json php7.0-mbstring php7.0-zip php7.0-xml php7.0-sqlite wget php7.0-imap
RUN usermod -u 1000 www-data

# Setting up Tideways profiler
RUN echo 'deb http://s3-eu-west-1.amazonaws.com/qafoo-profiler/packages debian main' > /etc/apt/sources.list.d/tideways.list
RUN wget -qO - https://s3-eu-west-1.amazonaws.com/qafoo-profiler/packages/EEB5E8F4.gpg | apt-key add -
RUN apt-get update
RUN apt-get install -y -qq tideways-daemon
RUN wget https://s3-eu-west-1.amazonaws.com/qafoo-profiler/downloads/testing/tideways-php_4.0.1_amd64.deb && dpkg -i tideways-php_4.0.1_amd64.deb
RUN echo "extension=tideways.so" > /etc/php/7.0/fpm/conf.d/tideways.ini
RUN echo "extension=tideways.so" > /etc/php/7.0/fpm/conf.d/tideways.ini

RUN cd opt/ && git clone https://github.com/letsencrypt/letsencrypt
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php -r "if (hash_file('SHA384', 'composer-setup.php') === '669656bab3166a7aff8a7506b8cb2d1c292f042046c5a994c43155c0be6190fa0355160742ab2e1c88d40d5be660b410') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
RUN php composer-setup.php
RUN php -r "unlink('composer-setup.php');"

# Adding the configuration files
RUN mkdir /run/php/ && chown -R www-data:www-data /run/php/
ADD conf/www.conf /etc/php/7.0/fpm/pool.d/www.conf
ADD conf/php-fpm.conf /etc/php/7.0/fpm/php-fpm.conf
# Add the run script to run the service
ADD run.sh /run.sh

#add the volume for the application
VOLUME /var/www/app

# Expose the port 9000
EXPOSE 9000
# Run the run.sh script
ENTRYPOINT [ "/bin/bash", "/run.sh"]
