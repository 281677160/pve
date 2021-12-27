#!/usr/bin/env bash

function system_check() {
  if [[ "$(. /etc/os-release && echo "$ID")" == "centos" ]]; then
    system_centos
  elif [[ "$(. /etc/os-release && echo "$ID")" == "ubuntu" ]]; then
    system_ubuntu
  elif [[ "$(. /etc/os-release && echo "$ID")" == "debian" ]]; then
    system_debian
  elif [[ "$(. /etc/os-release && echo "$ID")" == "alpine" ]]; then
    system_alpine
  else
    echo "不支持您的系统"
    exit 1
  fi
}

function system_centos() {
  if [[ ! -f /etc/ssh/sshd_config ]]; then
    yum install -y openssh-server
    systemctl enable sshd.service
    ssh_PermitRootLogin
    service sshd restart
  else
    ssh_PermitRootLogin
    service sshd restart
  fi
  echo "开启SSH完成"
}

function system_ubuntu() {
  if [[ ! -f /etc/ssh/sshd_config ]]; then
    apt-get -y update
    apt-get install -y openssh-server openssh-client
    ssh_PermitRootLogin
    service sshd restart
  else
    ssh_PermitRootLogin
    service ssh restart
  fi
  echo "开启SSH完成"
}

function system_debian() {
  if [[ ! -f /etc/ssh/sshd_config ]]; then
    apt -y update
    apt install -y openssh-server openssh-client
    ssh_PermitRootLogin
    service sshd restart
  else
    ssh_PermitRootLogin
    service ssh restart
  fi
  echo "开启SSH完成"
}

function system_alpine() {
  if [[ ! -f /etc/ssh/sshd_config ]]; then
    yum install -y openssh-server
    systemctl enable sshd.service
    ssh_PermitRootLogin
    service sshd restart
  else
    ssh_PermitRootLogin
    service sshd restart
  fi
  echo "开启SSH完成"
}

function ssh_PermitRootLogin() {
  if [[ `grep -c "ClientAliveInterval 30" /etc/ssh/sshd_config` == '0' ]]; then
    sed -i '/ClientAliveInterval/d' /etc/ssh/sshd_config
    sed -i '/ClientAliveCountMax/d' /etc/ssh/sshd_config
    sed -i '/PermitRootLogin/d' /etc/ssh/sshd_config
    sh -c 'echo ClientAliveInterval 30 >> /etc/ssh/sshd_config'
    sh -c 'echo ClientAliveCountMax 6 >> /etc/ssh/sshd_config'
    sh -c 'echo PermitRootLogin yes >> /etc/ssh/sshd_config'
  fi
}
system_check "$@"
