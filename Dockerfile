FROM centos:7

RUN yum install epel-release -y
RUN yum update -y
RUN yum groupinstall "Development Tools" "Development Libraries" -y
RUN curl -sL https://rpm.nodesource.com/setup_13.x | bash -
RUN yum install python3 neovim nodejs -y
RUN npm install -g yarn
RUN pip3 install neovim
RUN git config --global user.email "zxinmyth@gmail.com"
RUN git config --global user.name "onichandame"
RUN git config --global credential.helper cache
RUN git config --global credential.helper 'cache --timeout=86400'
COPY bashrc /root/.bashrc
COPY vimrc /root/.config/nvim/init.vim
COPY coc.json /root/.config/nvim/coc-settings.json
RUN curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
RUN nvim --headless +PlugInstall +qall
WORKDIR /root/.config/coc/extensions
RUN yarn add coc-ci coc-css coc-docker coc-eslint coc-explorer coc-json coc-markdownlint coc-pairs coc-python coc-snippets coc-tsserver coc-yaml
WORKDIR /
