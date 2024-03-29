#!/bin/bash

TIME() {
[[ -z "$1" ]] && {
	echo -ne " "
} || {
     case $1 in
	r) export Color="\e[31;1m";;
	g) export Color="\e[32;1m";;
	b) export Color="\e[34;1m";;
	y) export Color="\e[33;1m";;
	z) export Color="\e[35;1m";;
	l) export Color="\e[36;1m";;
      esac
	[[ $# -lt 2 ]] && echo -e "\e[36m\e[0m ${1}" || {
		echo -e "\e[36m\e[0m ${Color}${2}\e[0m"
	 }
      }
}
cp /etc/apt/sources.list /etc/apt/sources.list.bak
echo '
# 官方默认源
deb http://deb.debian.org/debian bullseye main contrib
deb http://deb.debian.org/debian bullseye-updates main contrib
deb http://security.debian.org bullseye-security main contrib
' > /etc/apt/sources.list
sed -i '1d' /etc/apt/sources.list
echo
TIME g "升级PVE"
echo
apt update -y
apt install -y net-tools curl wget sudo
apt dist-upgrade -y
echo
TIME g "更换LXC下载源"
echo
if [[ -f "/etc/apt/sources.list.d/pve-enterprise.list" ]]; then
  cp -fr /etc/apt/sources.list.d/pve-enterprise.list /etc/apt/sources.list.d/pve-enterprise.list.bak
  rm -rf /etc/apt/sources.list.d/pve-enterprise.list
fi
echo "deb http://mirrors.ustc.edu.cn/proxmox/debian/pve bullseye pve-no-subscription" >/etc/apt/sources.list.d/pve-install-repo.list
echo
TIME g "下载PVE7.0源的密匙!"
echo
cp -fr /etc/apt/trusted.gpg.d/proxmox-release-bullseye.gpg /etc/apt/trusted.gpg.d/proxmox-release-bullseye.gpg.bak
rm -fr /etc/apt/trusted.gpg.d/proxmox-release-bullseye.gpg
wget http://mirrors.ustc.edu.cn/proxmox/debian/proxmox-release-bullseye.gpg -O /etc/apt/trusted.gpg.d/proxmox-release-bullseye.gpg
if [[ $? -ne 0 ]];then
	wget http://mirrors.ustc.edu.cn/proxmox/debian/proxmox-release-bullseye.gpg -O /etc/apt/trusted.gpg.d/proxmox-release-bullseye.gpg
    	if [[ $? -ne 0 ]];then
      		TIME r "下载秘钥失败，请检查网络再尝试!"
      		sleep 2
      		exit 1
    	fi
fi
echo
TIME g "去掉无效订阅"
echo
cp /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js.bak
sed -i 's#if (res === null || res === undefined || !res || res#if (false) {#g' /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js
sed -i '/data.status.toLowerCase/d' /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js
echo
echo
sed -i 's#http://download.proxmox.com#https://mirrors.ustc.edu.cn/proxmox#g' /usr/share/perl5/PVE/APLInfo.pm
echo
TIME g "更换DNS为223.5.5.5和114.114.114.114"
echo
cp /etc/resolv.conf /etc/resolv.conf.bak
cp /etc/apt/sources.list.bak /etc/apt/sources.list
echo '
search com
nameserver 223.5.5.5
nameserver 114.114.114.114
' > /etc/resolv.conf
sed -i '1d' /etc/resolv.conf
rm -fr /root/pvehy.sh
echo
TIME g "重启PVE，需要几分钟时间，请耐心等候..."
echo
reboot
