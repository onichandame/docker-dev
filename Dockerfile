# latest go
FROM golang:alpine AS go

# glibc
FROM frolvlad/alpine-glibc:alpine-3.12 AS glibc
WORKDIR /usr
RUN tar -zcf glibc.tgz glibc-compat

#FROM alpine
FROM docker:dind
COPY --from=go /usr/local/go /usr/local/go
ENV PATH $PATH:/usr/local/go/bin

COPY --from=glibc /usr/glibc.tgz /usr
WORKDIR /usr
RUN tar -zxf glibc.tgz
RUN rm glibc.tgz
RUN ln -s /usr/glibc-compat/lib/ld-linux-x86-64.so.2 /lib/ld-linux-x86-64.so.2
WORKDIR /lib64
RUN ln -s /usr/glibc-compat/lib64/ld-linux-x86-64.so.2 /lib64/ld-linux-x86-64.so.2
WORKDIR /

# get configuration files ready
COPY ./files /files

# install basic tools
RUN apk update
RUN apk add busybox-extras python3 python3-dev py3-pip libffi-dev openssl-dev tmux mlocate musl-locales cmake clang-extra-tools htop curl openssh libpng-dev bash lcms2-dev iptraf-ng proxychains-ng automake autoconf libtool nasm util-linux docs

# install configuration files
ENV ENV /root/.bashrc
RUN cp /files/bashrc /root/.bashrc
RUN cp /files/tmux.conf /root/.tmux.conf

# install dev tools
RUN apk add gcc g++ make socat

# install git
RUN apk add git
RUN git config --global credential.helper cache
RUN git config --global credential.helper 'cache --timeout=86400'

# install nodejs
RUN apk add nodejs-current npm yarn
RUN yarn global add ts-node tsdx @nestjs/cli @nestjs/schematics http-server

# install neovim
RUN apk add neovim
RUN pip3 install neovim jedi pylama conan --ignore-installed six # conan depends on a different version of six
RUN mkdir -p /root/.config/nvim
RUN cp /files/vimrc /root/.config/nvim/init.vim
RUN curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
RUN nvim --headless +PlugInstall +qall
RUN mkdir -p /root/.config/coc/extensions
WORKDIR /root/.config/coc/extensions
# functioning extensions
RUN yarn add coc-docker coc-ci coc-css coc-explorer coc-json coc-markdownlint coc-pairs coc-python coc-snippets coc-tsserver coc-yaml coc-prettier coc-cmake coc-clangd coc-go
RUN cp /files/coc.json /root/.config/nvim/coc-settings.json

# install retry
WORKDIR /
RUN wget -O retry.tgz https://github.com/onichandame/retry/releases/download/v0.0.3/retry-v0.0.3-linux-amd64.tar.gz
RUN tar -zxf retry.tgz
RUN rm -f retry.tgz
RUN install retry /usr/bin
RUN rm -f retry

# go proxy
RUN go env -w GOPROXY=https://goproxy.cn,direct
RUN go env -w GO111MODULE=on

# use taobao mirror to bypass GFW. should be the last as image is built by Github workers outside China
RUN yarn global add yrm
RUN yrm use taobao

# use tsinghua pip source to speed up pip in China
WORKDIR /root/.pip
RUN cp /files/pip.conf ./pip.conf
WORKDIR /

# use aliyun apk source
WORKDIR /etc/apk
RUN cp /files/apk-repo ./repositories
RUN apk update
WORKDIR /

# clean configuration files
RUN rm -rf /files

WORKDIR /
