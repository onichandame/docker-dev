# get deno
FROM hayd/alpine-deno:1.1.3 AS deno
# deno depends on glibc
#FROM alpine:3
FROM frolvlad/alpine-glibc:alpine-3.12
COPY --from=deno /bin/deno /bin/deno

# get configuration files ready
COPY ./files /files

# install basic tools
RUN apk update
RUN apk add busybox-extras python3 python3-dev py3-pip tmux mlocate musl-locales cmake clang-extra-tools htop curl openssh libpng-dev bash lcms2-dev go iptraf-ng proxychains-ng

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

# install nodejs
RUN apk add nodejs npm yarn
RUN yarn global add tsdx # add tsdx as npx tsdx fails

# install neovim
RUN apk add neovim
RUN pip3 install neovim jedi pylama conan --ignore-installed six # conan depends on a different version of six
RUN mkdir -p /root/.config/nvim
RUN cp /files/vimrc /root/.config/nvim/init.vim
RUN curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
RUN nvim --headless +PlugInstall +qall
RUN mkdir -p /root/.config/coc/extensions
WORKDIR /root/.config/coc/extensions
RUN yarn add coc-ci coc-css coc-docker coc-explorer coc-json coc-markdownlint coc-pairs coc-python coc-snippets coc-tsserver coc-yaml coc-prettier coc-cmake coc-clangd coc-go # coc-deno
RUN cp /files/coc.json /root/.config/nvim/coc-settings.json

# install retry
WORKDIR /
RUN wget -O retry https://github.com/onichandame/retry/releases/download/v0.0.1/retry_linux_amd64
RUN install retry /usr/bin
RUN rm -f retry

# use taobao mirror to bypass GFW. should be the last as image is built by Github workers outside China
RUN npm config set disturl https://npm.taobao.org/dist --global
RUN npm config set registry https://registry.npm.taobao.org --global

# clean configuration files
RUN rm -rf /files

WORKDIR /

ENTRYPOINT ["ash"]
