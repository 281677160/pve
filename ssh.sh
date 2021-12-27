#!/usr/bin/env bash

function system_check() {
  if [[ "$(. /etc/os-release && echo "$ID")" == "centos" ]]; then
    if [[ ! -f /etc/ssh/sshd_config ]]; then
      yum install -y openssh-server
      systemctl enable sshd.service
      system_check
      service sshd restart
    else
      system_check
      service sshd restart
    fi
  elif [[ "$(. /etc/os-release && echo "$ID")" == "ubuntu" ]]; then
      system_check
      service ssh restart
  elif [[ "$(. /etc/os-release && echo "$ID")" == "debian" ]]; then
      system_check
      service ssh restart
  elif [[ "$(. /etc/os-release && echo "$ID")" == "alpine" ]]; then
    if [[ ! -f /etc/ssh/sshd_config ]]; then
      apk add openssh-server
      apk add openssh-client
      system_check
      service sshd restart
    else
      system_check
      service sshd restart
    fi
  else
    echo "不支持您的系统"
    exit 1
  fi
}

function system_check() {
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
