#!/bin/bash
function install_basic(){
  cd /
  dnf install epel-release -y
  rm -rf /var/cache/dnf
  dnf update -y
}

function install_tools(){
  cd /
  rm -rf /var/cache/dnf
  dnf install python3 tmux mlocate wget glibc-langpack-zh telnet which cmake clang-tools-extra -y
  cp /files/bashrc $HOME/.bashrc
  cp /files/tmux.conf $HOME/.tmux.conf
}

function install_devtools(){
  cd /
  rm -rf /var/cache/dnf
  dnf groupinstall "Development Tools" -y
}

function install_python(){
  cd /
  rm -rf /var/cache/dnf
  dnf install bzip2-devel libffi-devel wget zlib-devel openssl-devel readline-devel sqlite-devel -y
  dnf remove python3 -y
  wget https://www.python.org/ftp/python/3.8.3/Python-3.8.3.tgz
  tar -zxf Python-3.8.3.tgz
  cd Python-3.8.3
  ./configure --enable-optimizations
  make altinstall -sj
  ln -s /usr/local/bin/python3.8 /usr/local/bin/python3
  ln -s /usr/local/bin/pip3.8 /usr/local/bin/pip3
  cd -
  rm -rf Python-3.8.3*
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
  dnf install rsync libpng-devel -y
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

install_basic
install_tools
install_devtools
install_python
install_git
install_node
install_deno
install_neovim
