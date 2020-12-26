#!/bin/sh

function start_sshd(){
  chmod -R 0700 /root/.ssh
  ssh-keygen -A
  /usr/sbin/sshd
}

if [ -z "$DIND_DISABLED" ]
then
  dockerd-entrypoint.sh $DIND_ARGS
fi

if [ -z "$SSHD_DISABLED" ]
then
  start_sshd
fi
exec "$@"

#env | grep _ >> /etc/security/pam_env.conf
#pip3 install webssh
#wssh --port=3000 --origin="https://work.onichandame.com" --delay=6 --xheaders=False
