#!/bin/bash

if [ $# -eq 0 ]
  then
    service tideways-daemon start
    #starting php-fpm in foreground
    /usr/sbin/php-fpm7.0 -F
else
    php "$@"
fi