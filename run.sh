#!/bin/sh
ssh-keygen -A
/usr/sbin/sshd
dockerd-entrypoint.sh $@
