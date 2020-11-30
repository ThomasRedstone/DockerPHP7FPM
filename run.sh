#!/bin/bash

if [ $# -eq 0 ]
  then
    #starting php-fpm in foreground
    /usr/sbin/php-fpm7.4 -F
else
    php "$@"
fi