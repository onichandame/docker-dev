#!/bin/bash
cd /
dnf install epel-release -y
dnf groupinstall "Development Tools" -y
dnf config-manager --enable PowerTools
dnf config-manager --set-enabled PowerTools
dnf update -y
curl -fsSL https://deno.land/x/install/install.sh | sh
curl -sL https://rpm.nodesource.com/setup_14.x | bash -
dnf install rsync python3 nodejs tmux mlocate wget libpng-devel golang -y
npm install -g yarn

git config --global user.email "zxinmyth@gmail.com"
git config --global user.name "onichandame"
git config --global credential.helper cache
git config --global credential.helper 'cache --timeout=86400'

pip3 install neovim
wget https://github.com/neovim/neovim/releases/download/v0.4.3/nvim.appimage
chmod u+x nvim.appimage
/nvim.appimage --appimage-extract
rsync -a /squashfs-root/usr/ /usr/
rm -rf /nvim.appimage /squashfs-root
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
nvim --headless +PlugInstall +qall

mkdir -p $HOME/.config/coc/extensions
cd $HOME/.config/coc/extensions
yarn add coc-ci coc-css coc-docker coc-explorer coc-json coc-markdownlint coc-pairs coc-python coc-snippets coc-tsserver coc-yaml coc-prettier
