# Vagrant 自动化脚本

Vagrant可以快速部署虚拟化开发环境。而Laravel框架的Homestead事先在Ubuntu里封装了PHP的开发环境，让实现`快速`的目标更近一步。

但是想进一步熟练使用Linux，所以决定自己从Debian发行版部署环境，然后打包自己成自己的Box。

所以直接使用`Laravel Homestead`的脚本进行Vagrant的功能扩充。

似乎只要只要取消`parallels`的`v.update_guest_tools`就能顺利进入系统，文件共享成功，而不需要开启NFS。

# 资源

- [Vagrant](http://www.vagrantup.com/)

- [Laravel Homestead](http://laravel.com/docs/homestead)

- [Homestead via Github](https://github.com/laravel/homestead)
