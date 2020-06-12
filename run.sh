#!/bin/bash
function install_tools(){
  cd /
  dnf install epel-release -y
  dnf update -y
  dnf install python3 tmux mlocate wget golang glibc-langpack-zh telnet which cmake -y
  cp /files/bashrc $HOME/.bashrc
  cp /files/tmux.conf $HOME/.tmux.conf
}

function install_devtools(){
  cd /
  dnf groupinstall "Development Tools" -y
}

function install_node(){
  cd /
  curl -sL https://rpm.nodesource.com/setup_14.x | bash -
  dnf install nodejs -y
  npm install -g yarn
  yarn global add tsdx # add tsdx as npx tsdx fails
}

function install_deno(){
  cd /
  curl -fsSL https://deno.land/x/install/install.sh | sh
}

function install_neovim(){
  cd /
  dnf install python3 rsync libpng-devel -y
  pip3 install neovim
  wget https://github.com/neovim/neovim/releases/download/v0.4.3/nvim.appimage
  chmod u+x nvim.appimage
  /nvim.appimage --appimage-extract
  rsync -a /squashfs-root/usr/ /usr/
  rm -rf /nvim.appimage /squashfs-root
  mkdir -p $HOME/.config/nvim
  cp /files/vimrc $HOME/.config/nvim/init.vim
  curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  nvim --headless +PlugInstall +qall
  mkdir -p $HOME/.config/coc/extensions
  cd $HOME/.config/coc/extensions
  yarn add coc-ci coc-css coc-docker coc-explorer coc-json coc-markdownlint coc-pairs coc-python coc-snippets coc-tsserver coc-yaml coc-prettier coc-cmake coc-clangd # coc-deno
  mkdir $HOME/.config/nvim
  cp /files/coc.json $HOME/.config/nvim/coc-settings.json
}

function install_git(){
  dnf install git -y
  git config --global user.email "zxinmyth@gmail.com"
  git config --global user.name "onichandame"
  git config --global credential.helper cache
  git config --global credential.helper 'cache --timeout=86400'
}

install_tools
install_devtools
install_git
install_node
install_deno
install_neovim
