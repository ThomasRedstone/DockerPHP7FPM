#!/bin/bash

if [ $# -eq 0 ]
  then
    #starting php-fpm in foreground
    /usr/sbin/php-fpm7.2 -F
else
    php "$@"
fi