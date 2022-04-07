# pve

- 进入服务器后,切换到root用户,下面命令一般都切进入root用户,如果不行请自行百度
```sh
sudo -i || su - root
```

- 如果您服务器本身是没密码的,比如谷歌云，甲骨云这些，请设置密码
```sh
echo root:你想要设置的密码 |chpasswd root

比如：
echo root:adminadmin |chpasswd root
```

- 为防止系统没安装curl，使用不了一键命令，使用下面的一键命令之前先执行一次安装curl命令
```sh
apt -y update && apt -y install curl || yum install -y curl || apk add curl bash
```

- ### (centos、ubuntu、debian、alpine)一键开启root用户SSH连接
```sh
bash -c  "$(curl -fsSL https://ghproxy.com/https://raw.githubusercontent.com/281677160/pve/main/ssh.sh)"
```
---
- ### PVE一键升级PVE，lxc换源，去掉无效订阅
```sh
bash -c  "$(curl -fsSL https://ghproxy.com/https://raw.githubusercontent.com/281677160/pve/main/pvehy.sh)"
```
