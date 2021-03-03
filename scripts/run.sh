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
    case $NPM_REGISTRY in
      http* )
        yrm add custom $NPM_REGISTRY
        NPM_NAME=custom
        ;;
    esac
    yrm use $NPM_NAME
    if [ -n "$NPM_USERNAME" ]
    then
      login_npm $NPM_USERNAME $NPM_PASSWORD $NPM_EMAIL
    fi
  fi
}

function configure_git(){
  git config --global pull.rebase false # merge to solve conflicts
  if [ -n "$GIT_USER_NAME" ]
  then
    git config --global user.name "$GIT_USER_NAME"
  fi
  if [ -n "$GIT_USER_EMAIL" ]
  then
    git config --global user.email "$GIT_USER_EMAIL"
  fi
}

function start_ipfs(){
  if [ -n "$IPFS_ENABLED" ]
  then
    apk add go-ipfs && \
      ipfs init && \
      ipfs config --json Swarm.EnableAutoRelay 'true' && \
      ipfs daemon --enable-pubsub-experiment &
  fi
}

function start_dockerd(){
  if [ -n "$DIND_ENABLED" ]
  then
    dockerd-entrypoint.sh $DIND_ARGS &
  fi
}

function start_sshd(){
  if [ -n "$SSHD_ENABLED" ]
  then
    start_sshd &
  fi
}

configure_npm
configure_git
start_dockerd
start_sshd
start_ipfs

"$@"

wait
