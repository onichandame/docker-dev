#!/bin/sh
ssh-keygen -A
chmod -R 0700 /root/.ssh

/usr/sbin/sshd

dockerd-entrypoint.sh $@
