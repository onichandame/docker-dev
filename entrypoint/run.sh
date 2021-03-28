#!/bin/sh

function start_sshd(){
  if [ -n "$SSHD_ENABLED" ]
  then
    echo sshd starting
    CONFIG_DIR=$HOME/.ssh
    mkdir -p $CONFIG_DIR
    for i in $(echo $SSH_KEYS | tr ";" "\n")
    do
      echo $i >> $CONFIG_DIR/authorized_keys
    done
    ssh-keygen -A
    chmod -R 0700 /root/.ssh
    /usr/sbin/sshd
    echo sshd started
  fi
}

function login_npm(){
  echo npm logging in
  apk add expect
  $(dirname $0)/login_npm.sh $@
  echo npm logged in
}

function configure_npm(){
  if [ -n "$NPM_REGISTRY" ]
  then
    echo npm configuring
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
    echo npm configured
  fi
}

function configure_git(){
  echo git configuring
  git config --global pull.rebase false # merge to solve conflicts
  if [ -n "$GIT_USER_NAME" ]
  then
    git config --global user.name "$GIT_USER_NAME"
  fi
  if [ -n "$GIT_USER_EMAIL" ]
  then
    git config --global user.email "$GIT_USER_EMAIL"
  fi
  echo git configured
}

function start_ipfs(){
  if [ -n "$IPFS_ENABLED" ]
  then
    echo ipfs starting
    apk add go-ipfs && \
      ipfs init && \
      ipfs config --json Swarm.EnableAutoRelay 'true' && \
      ipfs config --json Experimental.Libp2pStreamMounting true && \
      ipfs daemon --enable-pubsub-experiment &
    echo ipfs started
  fi
}

function start_dockerd(){
  if [ -n "$DIND_ENABLED" ]
  then
    echo docker starting
    dockerd-entrypoint.sh $DIND_ARGS &
    echo docker started
  fi
}

configure_npm
configure_git
start_dockerd
start_sshd
start_ipfs

"$@"

wait
