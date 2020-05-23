FROM centos:8

COPY bashrc /root/.bashrc
COPY tmux.conf /root/.tmux.conf

COPY vimrc /root/.config/nvim/init.vim
COPY coc.json /root/.config/nvim/coc-settings.json

ADD run.sh /run.sh
RUN bash /run.sh
RUN rm /run.sh

WORKDIR /
