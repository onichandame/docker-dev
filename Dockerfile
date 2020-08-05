# get deno and node 8
#FROM hayd/alpine-deno:1.1.3 AS deno
# deno depends on glibc
#FROM alpine:3
#FROM frolvlad/alpine-glibc:alpine-3.12
#COPY --from=deno /bin/deno /bin/deno
#COPY --from=node8 /usr/local/bin/node /usr/local/bin/node
#COPY --from=node8 /usr/local/bin/npm /usr/local/bin/npm
#COPY --from=node8 /usr/local/bin/yarn /usr/local/bin/yarn
#RUN apk add libstdc++ # node 8 depends on libstdc++
# get node 8
FROM node:10-alpine AS node10
RUN yarn global add tsdx # add tsdx as npx tsdx fails

# get configuration files ready
COPY ./files /files

# install basic tools
RUN apk update
RUN apk add busybox-extras python3 python3-dev py3-pip tmux mlocate musl-locales cmake clang-extra-tools htop curl openssh libpng-dev bash lcms2-dev go

# install configuration files
ENV ENV /root/.bashrc
RUN cp /files/bashrc /root/.bashrc
RUN cp /files/tmux.conf /root/.tmux.conf

# install dev tools
RUN apk add gcc g++ make

# install git
RUN apk add git
RUN git config --global credential.helper cache
RUN git config --global credential.helper 'cache --timeout=86400'

# install neovim
RUN apk add neovim
RUN pip3 install neovim jedi pylama conan --ignore-installed six # conan depends on a different version of six
RUN mkdir -p /root/.config/nvim
RUN cp /files/vimrc /root/.config/nvim/init.vim
RUN curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
RUN nvim --headless +PlugInstall +qall
RUN mkdir -p /root/.config/coc/extensions
WORKDIR /root/.config/coc/extensions
RUN yarn add coc-ci coc-css coc-docker coc-explorer coc-json coc-markdownlint coc-pairs coc-python coc-snippets coc-tsserver coc-yaml coc-tslint coc-cmake coc-clangd coc-go # coc-deno
RUN cp /files/coc.json /root/.config/nvim/coc-settings.json

# install retry
WORKDIR /
RUN wget -O retry https://github.com/onichandame/retry/releases/download/v0.0/retry_linux_amd64
RUN install retry /usr/bin
RUN rm -f retry

# clean configuration files
RUN rm -rf /files

WORKDIR /

ENTRYPOINT ["ash"]
