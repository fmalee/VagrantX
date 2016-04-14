#!/usr/bin/env bash

# sed -i "s?^datadir.*?datadir = $1?" /etc/mysql/my.cnf
# sed -i ":begin; /#vagrant_b/,/vagrant_e/ { /vagrant_e/! { $! { N; b begin }; }; s/#vagrant_b.*vagrant_e//; };"  /etc/apparmor.d/usr.sbin.mysqld
# sed -i "\/var\/lib\/mysql\/\*\* rwk,/a\  #vagrant_b\n  $1 r,\n  $1\/** rwk,\n  #vagrant_e" /etc/apparmor.d/usr.sbin.mysqld

/etc/init.d/rpcbind restart
/etc/init.d/apparmor restart
/etc/init.d/mysql stop
/etc/init.d/mysql start
