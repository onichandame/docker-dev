FROM centos:7

RUN yum install epel-release -y
RUN yum update -y
RUN yum groupinstall "Development Tools" "Development Libraries" -y
RUN curl -sL https://rpm.nodesource.com/setup_13.x | bash -
RUN yum install neovim nodejs yarn -y
COPY bashrc /root/.bashrc
COPY vimrc /root/.config/nvim/init.vim
RUN curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
RUN nvim --headless +PlugInstall +qall
