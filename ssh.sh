#!/usr/bin/env bash

if [[ ! "$USER" == "root" ]]; then
   echo -e "\033[41;33m 警告：请使用root用户操作!~~  \033[0m"
   exit 1
fi

function system_check() {
  if [[ "$(. /etc/os-release && echo "$ID")" == "centos" ]]; then
    yum install -y sudo
    system_centos
  elif [[ "$(. /etc/os-release && echo "$ID")" == "ubuntu" ]]; then
    apt -y update
    apt-get install -y sudo
    system_ubuntu
  elif [[ "$(. /etc/os-release && echo "$ID")" == "debian" ]]; then
    apt -y update
    apt install -y sudo
    system_debian
  elif [[ "$(. /etc/os-release && echo "$ID")" == "alpine" ]]; then
    apk add sudo
    system_alpine
  else
    echo -e "\033[41;33m 不支持您的系统  \033[0m"
    exit 1
  fi
}

function system_centos() {
  if [[ ! -f /etc/ssh/sshd_config ]]; then
    echo -e "\033[33m 安装SSH \033[0m"
    yum install -y openssh-server
    systemctl enable sshd.service
    ssh_PermitRootLogin
    sudo service sshd restart
  else
    ssh_PermitRootLogin
    sudo service sshd restart
  fi
  echo -e "\033[32m 开启root账户SSH完成 \033[0m"
  exit 0
}

function system_ubuntu() {
  if [[ ! -f /etc/ssh/sshd_config ]]; then
    echo -e "\033[33m 安装SSH \033[0m"
    apt-get install -y openssh-server
    ssh_PermitRootLogin
    sudo service ssh restart
  else
    ssh_PermitRootLogin
    sudo service ssh restart
  fi
  echo -e "\033[32m 开启root账户SSH完成 \033[0m"
  exit 0
}

function system_debian() {
  if [[ ! -f /etc/ssh/sshd_config ]]; then
    echo -e "\033[33m 安装SSH \033[0m"
    apt install -y openssh-server
    ssh_PermitRootLogin
    sudo service ssh restart
  else
    ssh_PermitRootLogin
    sudo service ssh restart
  fi
  echo -e "\033[32m 开启root账户SSH完成 \033[0m"
  exit 0
}

function system_alpine() {
  if [[ ! -f /etc/ssh/sshd_config ]]; then
    echo -e "\033[33m 安装SSH \033[0m"
    apk add openssh-server
    apk add openssh-client
    rc-update add sshd
    ssh_PermitRootLogin
    sudo service sshd restart
  else
    ssh_PermitRootLogin
    sudo service sshd restart
  fi
  echo -e "\033[32m 开启root账户SSH完成 \033[0m"
  exit 0
}

function ssh_PermitRootLogin() {
  if [[ `grep -c "ClientAliveInterval 30" /etc/ssh/sshd_config` == '0' ]]; then
    sudo sed -i '/ClientAliveInterval/d' /etc/ssh/sshd_config
    sudo sed -i '/ClientAliveCountMax/d' /etc/ssh/sshd_config
    sudo sh -c 'echo ClientAliveInterval 30 >> /etc/ssh/sshd_config'
    sudo sh -c 'echo ClientAliveCountMax 6 >> /etc/ssh/sshd_config'
  fi
  sudo sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin yes/g' /etc/ssh/sshd_config
  sudo sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/g' /etc/ssh/sshd_config
}
system_check "$@"
