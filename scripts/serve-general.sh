#!/usr/bin/env bash

block="server {
    listen ${3:-80};
    server_name $1;
    root \"$2\";

    charset utf-8;

    access_log  /var/log/nginx/$1-access.log;
    error_log  /var/log/nginx/$1-error.log;

    location / {
        index  index.html index.htm index.php;
        autoindex   on;
    }

    location ~ \.php$ {
        fastcgi_pass unix:/var/run/php/php7.0-fpm.sock;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;

        fastcgi_intercept_errors off;
        fastcgi_buffer_size 16k;
        fastcgi_buffers 4 16k;
        fastcgi_connect_timeout 300;
        fastcgi_send_timeout 300;
        fastcgi_read_timeout 300;
    }
}
"

echo "$block" > "/etc/nginx/sites-available/$1"
ln -fs "/etc/nginx/sites-available/$1" "/etc/nginx/sites-enabled/$1"
service nginx restart
