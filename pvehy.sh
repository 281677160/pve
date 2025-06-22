#!/bin/bash

# 定义函数以减少重复代码
backup_file() {
    if [[ -f "$1" ]]; then
        cp "$1" "$1.bak"
    fi
}

rmfr_file() {
    if [[ -f "$1" ]]; then
        cp "$1" "$1.bak"
        rm -fr "$1"
    fi
}

replace_sources_list() {
    local file_path="$1"
    local new_content="$2"
    backup_file "$file_path"
    echo "$new_content" > "$file_path"
    sed -i '1d' "$file_path"
}

# 更换sources.list源
replace_sources_list "/etc/apt/sources.list" "
deb https://mirrors.ustc.edu.cn/debian/ bookworm main contrib non-free non-free-firmware
deb https://mirrors.ustc.edu.cn/debian/ bookworm-updates main contrib non-free non-free-firmware
deb https://mirrors.ustc.edu.cn/debian/ bookworm-backports main contrib non-free non-free-firmware
deb https://mirrors.ustc.edu.cn/debian-security bookworm-security main
"
# 更换ceph.list源
replace_sources_list "/etc/apt/sources.list.d/ceph.list" "deb https://mirrors.ustc.edu.cn/proxmox/debian/ceph-quincy bookworm no-subscription"

# 更换pve-enterprise.list源
replace_sources_list "/etc/apt/sources.list.d/pve-enterprise.list" "deb https://mirrors.ustc.edu.cn/proxmox/debian bookworm pve-no-subscription"

# 更换pve-install-repo.list源
replace_sources_list "/etc/apt/sources.list.d/pve-install-repo.list" "deb http://mirrors.ustc.edu.cn/proxmox/debian/pve bullseye pve-no-subscription"

# 更换LXC仓库源
sed -i 's#url => "http.*/images"#url => "https://mirrors.ustc.edu.cn/proxmox/images"#g' "/usr/share/perl5/PVE/APLInfo.pm"

apt update -y
dpkg --configure -a
apt install -y net-tools wget

# 下载PVE8.0源的密匙并验证
rmfr_file "/etc/apt/trusted.gpg.d/proxmox-release-bookworm.gpg"
wget https://mirrors.ustc.edu.cn/proxmox/debian/proxmox-release-bookworm.gpg -O /etc/apt/trusted.gpg.d/proxmox-release-bullseye.gpg
if [[ $? -ne 0 ]];then
	curl -o /etc/apt/trusted.gpg.d/proxmox-release-bullseye.gpg https://mirrors.ustc.edu.cn/proxmox/debian/proxmox-release-bookworm.gpg
    	if [[ $? -ne 0 ]];then
            cp -fr /etc/apt/trusted.gpg.d/proxmox-release-bookworm.gpg.bak /etc/apt/trusted.gpg.d/proxmox-release-bookworm.gpg
      		echo "下载秘钥失败，请检查网络再尝试!"
      		sleep 2
      		exit 1
    	fi
else
    echo "PVE8.0源的密匙更新完成"
fi

# 升级PVE
echo "更新文件源"
apt update -y
echo "升级PVE,所需时间或比较长,请耐心等候......"
apt dist-upgrade -y

# 去掉无效订阅
backup_file "/usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js"
sed -i 's#if (res === null || res === undefined || !res || res#if (false) {#g' "/usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js"
sed -i '/data.status.toLowerCase/d' "/usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js"
echo "去除无效订阅弹窗完成"

# 设置Web控制台默认语言为中文
if grep -q 'zh_CN' /etc/pve/datacenter.cfg; then
    echo "Web默认语言已为中文"
else
    cp -fr /etc/pve/datacenter.cfg /etc/pve/datacenter.cfg.bak
    echo 'language: zh_CN' >> /etc/pve/datacenter.cfg
    echo "设置Web默认语言为中文完成"
fi

# 更换DNS
replace_sources_list "/etc/resolv.conf" "
search com
nameserver 223.5.5.5
nameserver 114.114.114.114
"
echo "更换DNS完成"
echo "重启PVE，需要几分钟时间，请耐心等候..."
reboot
