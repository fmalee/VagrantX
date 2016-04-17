#!/usr/bin/env bash

if [ -d $1 ]; then
	# 变更datadir目录
	sed -i "s?^datadir.*?datadir = $1?" /etc/mysql/my.cnf
	# 清理之前添加的apparmor目录权限
	sed -i 'N;N;s/# Change_Datadir_end\n/# Change_Datadir_end/' /etc/apparmor.d/usr.sbin.mysqld
	sed -i ":begin; /# Change_Datadir_begin/,/Change_Datadir_end/ { /Change_Datadir_end/! { $! { N; b begin }; }; s/# Change_Datadir_begin.*Change_Datadir_end//; };" /etc/apparmor.d/usr.sbin.mysqld

	if [ $1 != "/var/lib/mysql" ]; then
		# 在apparmor中添加目录权限
		sed -i "\/var\/lib\/mysql\/\*\* rwk,/a\# Change_Datadir_begin\n  $1/ r,\n  $1\/** rwk,\n# Change_Datadir_end" /etc/apparmor.d/usr.sbin.mysqld

		/etc/init.d/apparmor restart
	fi

	/etc/init.d/mysql restart
else
	echo '==> No such directory, Please use the path in the Guest OS'
fi
