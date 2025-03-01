# pve

- 为防止系统没安装curl，使用不了一键命令，使用下面的一键命令之前先执行一次安装curl命令
```sh
apt -y update && apt -y install curl || yum install -y curl || apk add curl bash
```

- ### (centos、ubuntu、debian、alpine)一键开启root用户SSH连接
```sh
bash -c  "$(curl -fsSL https://ghfast.top/https://raw.githubusercontent.com/281677160/pve/main/ssh.sh)"
```
---
- ### PVE8.0一键升级PVE，lxc换源，去掉订阅弹窗，设置WEB登录默认中文
```sh
bash -c  "$(curl -fsSL https://ghfast.top/https://raw.githubusercontent.com/281677160/pve/main/pvehy.sh)"
```
---
- ### 记录一下PVE安装openwrt时候转换固件格式命令
```sh
qm importdisk 虚拟机ID /var/lib/vz/template/iso/固件名字 local-lvm

比如：

qm importdisk 101 /var/lib/vz/template/iso/x86-64.img local-lvm
```


