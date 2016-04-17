#!/usr/bin/env bash

# Update Composer
if [ -e /usr/local/bin/composer ]; then
    /usr/local/bin/composer self-update
fi

echo "==> Updating the package list"
if [ $1 ]; then
	echo "==> Updating with proxy"
	apt-get -y -o Acquire::http::proxy='$1' update

else
	apt-get -y update
fi
