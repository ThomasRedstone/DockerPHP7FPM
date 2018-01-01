#!/bin/bash

if [ $# -eq 0 ]
  then
    #starting php-fpm in foreground
    ls -ltrah /usr/sbin/php-fpm*
    /usr/sbin/php-fpm7.1 -F
else
    php "$@"
fi