#!/bin/sh

function start_sshd(){
  chmod -R 0700 /root/.ssh
  ssh-keygen -A
  /usr/sbin/sshd
}

function login_npm(){
  apk add expect
  $(dirname $0)/login_npm.sh $@
}

function configure_npm(){
  if [ -n "$NPM_REGISTRY" ]
  then
    NPM_NAME=$NPM_REGISTRY
    if [ $NPM_REGISTRY == http* ]
    then
      yrm add custom $NPM_REGISTRY
      NPM_NAME=custom
    fi
    yrm use $NPM_NAME
    if [ -n "$NPM_USERNAME" ]
    then
      login_npm $NPM_USERNAME $NPM_PASSWORD $NPM_EMAIL
    fi
  fi
}

configure_npm

if [ -z "$DIND_DISABLED" ]
then
  dockerd-entrypoint.sh $DIND_ARGS &
fi

if [ -z "$SSHD_DISABLED" ]
then
  start_sshd &
fi
"$@"
wait

#env | grep _ >> /etc/security/pam_env.conf
#pip3 install webssh
#wssh --port=3000 --origin="https://work.onichandame.com" --delay=6 --xheaders=False
