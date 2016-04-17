#!/usr/bin/env bash

# Clear The Old Environment Variables
if [ -e /home/vagrant/.profile ]; then
	sed -i '/# Set VagrantX Environment Variable/,+1d' /home/vagrant/.profile
fi

if [ -e /etc/php/7.0/fpm/php-fpm.conf ]; then
	sed -i '/env\[.*/,+1d' /etc/php/7.0/fpm/php-fpm.conf
fi
