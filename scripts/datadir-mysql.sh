#!/usr/bin/env bash

if [ -d $1 ]; then
	# 变更datadir目录
	sed -i "s?^datadir.*?datadir = $1?" /etc/mysql/my.cnf
	# 清理之前添加的apparmor目录权限
	sed -i '/# Allow new data dir access/,+3d' /etc/apparmor.d/usr.sbin.mysqld

	if [ $1 != "/var/lib/mysql" ]; then
		# 在apparmor中添加目录权限
		sed -i "\/var\/lib\/mysql\/\*\* rwk,/a\ \n# Allow new data dir access\n  $1\/ r,\n  $1\/** rwk," /etc/apparmor.d/usr.sbin.mysqld

		/etc/init.d/apparmor restart
	fi

	/etc/init.d/mysql restart
else
	echo '==> No such directory, Please use the path in the Guest OS'
fi
