FROM thomasredstone/base
# Install php-fpm
RUN apt-get update -qq && apt-get -y upgrade
RUN apt-get install -y -qq software-properties-common && add-apt-repository ppa:ondrej/php && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4F4EA0AAE5267A6C

RUN apt-get update && apt-get -y -qq install curl libcurl3 libcurl3-dev php7.0-fpm php7.0-mysql php7.0-curl php7.0-json wget
RUN usermod -u 1000 www-data
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