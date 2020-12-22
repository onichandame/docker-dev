#!/bin/sh
ssh-keygen -A
chmod -R 0700 /root/.ssh

/usr/sbin/sshd

#env | grep _ >> /etc/security/pam_env.conf
#pip3 install webssh
#wssh --port=3000 --origin="https://work.onichandame.com" --delay=6 --xheaders=False

dockerd-entrypoint.sh $@
