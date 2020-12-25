#!/bin/sh

function start_sshd(){
  chmod -R 0700 /root/.ssh
  ssh-keygen -A
  /usr/sbin/sshd
}

if [ $MODE == "min" ]
then
  exec "$@"
  return
elif [ $MODE == "dind" ]
then
  dockerd-entrypoint.sh $@
  return
else
  start_sshd
  dockerd-entrypoint.sh $@
  return
fi

#env | grep _ >> /etc/security/pam_env.conf
#pip3 install webssh
#wssh --port=3000 --origin="https://work.onichandame.com" --delay=6 --xheaders=False
