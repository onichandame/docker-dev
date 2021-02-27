# escape=`
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

# install basic tools
RUN apk update
RUN apk add busybox-extras python3 python3-dev py3-pip libffi-dev openssl-dev tmux mlocate musl-locales cmake clang-extra-tools htop curl openssh openssh-server-pam libpng-dev bash lcms2-dev iptraf-ng proxychains-ng automake autoconf libtool nasm docs bind-tools vips-dev

# install configuration files
ENV ENV /root/.bashrc
ADD files/bashrc /root/.bashrc
ADD files/tmux.conf /root/.tmux.conf

# install dev tools
RUN apk add gcc g++ make socat

# install git
RUN apk add git

# install nodejs
RUN apk add nodejs-current npm yarn
RUN yarn global add ts-node @nestjs/cli @nestjs/schematics http-server lerna

# install chromium for puppeteer, which is needed by mermaid
RUN apk add --no-cache chromium nss freetype freetype-dev harfbuzz ca-certificates ttf-freefont nodejs yarn
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

# install neovim
RUN apk add neovim
RUN pip3 install neovim jedi pylama conan --ignore-installed six # conan depends on a different version of six
RUN mkdir -p /root/.config/nvim
ADD files/vimrc /root/.config/nvim/init.vim
ADD files/vimdict /root/.config/nvim/spell
RUN curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
RUN nvim --headless +PlugInstall +qall
RUN mkdir -p /root/.config/coc/extensions

# functioning extensions
WORKDIR /root/.config/coc/extensions
RUN timeout 1m nvim --headless +CocInstall`
\ coc-ci`
\ coc-css`
\ coc-explorer`
\ coc-json`
\ coc-markdownlint`
\ coc-pairs`
\ coc-pyright`
\ coc-snippets`
\ coc-tsserver`
\ coc-yaml`
\ coc-prettier`
\ coc-cmake`
\ coc-clangd`
\ coc-go`
\ coc-vimlsp`
\ coc-git`
\ coc-docker`
\ coc-sh`
; exit 0
ADD files/coc.json /root/.config/nvim/coc-settings.json

# htop configuration
WORKDIR /root/.config/htop
ADD files/htoprc /root/.config/htop/htoprc
WORKDIR /

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

# install npm and yarn registry manager. check run.sh to see how to configure
RUN yarn global add yrm --prefix /usr/local
RUN npm config set always-auth true # needed to make yarn work with private registry

# use tsinghua pip source to speed up pip in China
WORKDIR /root/.pip
ADD files/pip.conf ./pip.conf
WORKDIR /

# use aliyun apk source
WORKDIR /etc/apk
ADD files/apk-repo ./repositories
RUN apk update
WORKDIR /

# run services
WORKDIR /etc/ssh
ADD files/sshd_config /etc/ssh/sshd_config
WORKDIR /
ADD scripts /entrypoint
RUN chmod -R +x /entrypoint
ENTRYPOINT ["/entrypoint/run.sh"]
