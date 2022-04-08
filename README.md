# pve

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
