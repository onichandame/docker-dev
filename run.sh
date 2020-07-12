#!/bin/bash
function install_basic(){
  cd /
  apk update
  apk add busybox-extras
}

function install_tools(){
  cd /
  apk add python3 py3-pip tmux bash mlocate musl-locale cmake clang-extra-tools htop curl
  cp /files/bashrc $HOME/.bashrc
  cp /files/tmux.conf $HOME/.tmux.conf
}

function install_devtools(){
  apk add gcc g++ make
}

function install_node(){
  apk add nodejs npm yarn
  yarn global add tsdx # add tsdx as npx tsdx fails
}

# deno does not support musl yet
#function install_deno(){
#  curl -fsSL https://deno.land/x/install/install.sh | sh
#}

function install_neovim(){
  apk add neovim
  pip3 install neovim jedi pylama conan
  mkdir -p $HOME/.config/nvim
  cp /files/vimrc $HOME/.config/nvim/init.vim
  curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  nvim --headless +PlugInstall +qall
  mkdir -p $HOME/.config/coc/extensions
  cd $HOME/.config/coc/extensions
  yarn add coc-ci coc-css coc-docker coc-explorer coc-json coc-markdownlint coc-pairs coc-python coc-snippets coc-tsserver coc-yaml coc-eslint coc-cmake coc-clangd # coc-deno
  cp /files/coc.json $HOME/.config/nvim/coc-settings.json
}

function install_git(){
  apk add git -y
  git config --global credential.helper cache
  git config --global credential.helper 'cache --timeout=86400'
}

install_basic
install_tools
install_devtools
install_git
install_node
install_neovim
