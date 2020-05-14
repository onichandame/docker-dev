FROM centos:8

RUN dnf install epel-release -y
RUN dnf groupinstall "Development Tools" -y
RUN dnf config-manager --enable PowerTools
RUN dnf config-manager --set-enabled PowerTools
RUN dnf update -y
RUN curl -sL https://rpm.nodesource.com/setup_14.x | bash -
RUN dnf install rsync python3 nodejs tmux mlocate wget golang -y
RUN npm install -g yarn
RUN pip3 install neovim
RUN git config --global user.email "zxinmyth@gmail.com"
RUN git config --global user.name "onichandame"
RUN git config --global credential.helper cache
RUN git config --global credential.helper 'cache --timeout=86400'
WORKDIR /
RUN wget https://github.com/neovim/neovim/releases/download/v0.4.3/nvim.appimage
RUN chmod u+x nvim.appimage
RUN /nvim.appimage --appimage-extract
RUN rsync -a /squashfs-root/usr/ /usr/
RUN rm -rf /nvim.appimage /squashfs-root
COPY bashrc /root/.bashrc
COPY vimrc /root/.config/nvim/init.vim
COPY tmux.conf /root/.tmux.conf
COPY coc.json /root/.config/nvim/coc-settings.json
RUN curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
RUN nvim --headless +PlugInstall +qall
WORKDIR /root/.config/coc/extensions
RUN yarn add coc-ci coc-css coc-docker coc-explorer coc-json coc-markdownlint coc-pairs coc-python coc-snippets coc-tsserver coc-yaml coc-prettier
WORKDIR /
