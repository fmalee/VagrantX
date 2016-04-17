# Vagrant 自动化脚本

Vagrant可以快速部署虚拟化开发环境。而Laravel框架的Homestead事先在Ubuntu里封装了PHP的开发环境，让实现`快速`的目标更近一步。

但是想进一步熟练使用Linux，所以决定自己从Debian发行版部署环境，然后打包自己成自己的Box。

所以直接使用`Laravel Homestead`的脚本进行Vagrant的功能扩充。

# 增加和修改的部分

- 将`Homestead `修改为VagrantX
- 建立说明文档
- 清理无用文件，简化项目
- 将配置文件移到上级目录`src`，然后将`src`改名为`vagrant.d`，因为`src`在很多项目中很常见，容易冲突
- 将配置文件和`scripts`脚本目录都初始化到`~/.vagrantX`目录，方便统一管理。
- 同时允许个性化项目，只要将配置文件放置在项目目录下，脚本优先读取，方便部署多个案例。
- 增加Nginx站点的常规配置脚本
- 增加`datadir`配置选项，将本机数据库目录映射到虚拟机的数据库目录，让数据在本地以保证虚拟机被玩坏后的数据安全。
- 增加`apt_proxy`配置选项。默认Vagrant首次启动会更新APT，可以用`apt_proxy`配置代理。
- 似乎只要只要取消`parallels`的`v.update_guest_tools`就能顺利进入系统，文件共享成功，而不需要开启NFS。
- 其他小调整

# 待完善

 - 修改默认端口逻辑：如果用户配置自己的端口映射，那么默认端口映射都取消
 - 调整`Variable`的变量处理机制
 - `init.sh`脚本的`awk`变量处理

# 疑难问题

## MySQL数据库映射手记
希望将虚拟机的MySQL数据库用本地数据库映射，这样Vagrant不小心销毁也不会丢失数据库。
现在的情况是MySQL经常无法启动，无论是直接映射覆盖`/var/lib/mysql`，还是修改数据库目录和增加`apparmor`权限。
一般都是`InnoDB: Unable to lock ./ib_logfile1, error: 11`错误。
这个和权限有关的错误可能是和NFS本身有关。MySQL认为有另一个进程在使用InnoDB文件。
删除`ibdata1`,`ib_logfile0`,`ib_logfile1`三个文件让MySQL重建就能启动，可是这和备份数据的初衷不符合。

### 解决

这个情况一般是发生在多个虚拟机交替使用同一个本地的数据库目录造成的权限锁死。
所以最终还是就因为`InnoDB`的问题导致无法启动，也就是NFS权限的问题，MySQL认为该文件其他进程在使用。
暂时没有好的解决办法。
只能是一台虚拟机对应一个数据库目录。
如果锁死，手动重置自己主机的NFS。

### 折腾过程

试了不少方法都没有成功，先搁置：
- 修改主机目录权限为最大

- 修改UID和GID为虚拟机上Mysql一致，权限一致。

- mv三个文件在cp回来。

- 使用虚拟机自带的共享功能映射。

- 之前试验的时候，虚拟机第二次重启后映射都能正常启动，所以做了脚本判断是否第一次启动虚拟机。后来发现就算这样成功了也很不理想，因为在`Vagrantfile`内部没法像插件一样回调Vagrant命令，最多只能让`shell`在虚拟机内部执行，所以还是需要手动`Vagrant up`。

- 看错误日志，以为是MySQL5.6的插件导致无法启动，所以删除所有四个插件，结果是插件的Error不影响启动。

- 将NFS设置为`:map_uid => 'mysql',:map_gid => 'mysql'`会导致`Can't read dir of '.' (errno: 13 - Permission denied)`错误，还是权限问题。

- Ubuntu下只装了`nfs-common`，所以和NFS相关的只有一个RPC服务：`rpcbind`，尝试重启不起作用。

- 将本地之前的数据库cp到虚拟机目录，修改权限，MySQL能正常启动。

- 将`/var/lib/mysql`数据库复制到本地映射，正常启动。

- 删除`ibdata1`,`ib_logfile0`,`ib_logfile1`三个文件让MySQL重建就能启动。

### 其他未整理

#### `InnoDB`常规解决办法

sudo mv ibdata1 ibdata1.bak
sudo cp -a ibdata1.bak ibdata1
sudo mv ib_logfile0 ib_logfile0.bak
sudo cp -a ib_logfile0.bak ib_logfile0
sudo mv ib_logfile1 ib_logfile1.bak
sudo cp -a ib_logfile1.bak ib_logfile1

#### 数据库权限

sudo chown -R mysql:mysql /var/mysql
sudo chown -R mysql:root /var/mysql/mysql

sudo chown -R root:root /var/mysql/debian-5.6.flag
sudo chown -R root:root /var/mysql/mysql_upgrade_info

sudo vi /etc/mysql/my.cnf
datadir = /var/mysql

sudo service mysql restart
sudo service rpcbind restart

#### apparmor权限
sudo cp /etc/apparmor.d/usr.sbin.mysqld /etc/apparmor.d/usr.sbin.mysqld.bak
sudo vi /etc/apparmor.d/usr.sbin.mysqld

/var/mysql r,
/var/mysql** rwk,

sudo /etc/init.d/apparmor restart

#### 其他操作

showmount -e 192.168.0.2 #查看NFS挂载
sudo nfsd enable #确认NFSD服务开启
sudo nfsd update #刷新NFSD共享资源
showmount -e #显示当前共享的资源

# 资源

- [Vagrant](http://www.vagrantup.com/)

- [Laravel Homestead](http://laravel.com/docs/homestead)

- [Homestead via Github](https://github.com/laravel/homestead)
