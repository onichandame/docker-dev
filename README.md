# docker-dev

docker image for development

# Author

[onichandame](https://github.com/onichandame)

# Features

- CentOS 8 CLI
- Common CLI tools
- Common development tools
- Node.js 14
- Deno
- Neovim with coc.nvim
- git(with hard coded user name and email)

# Usage

## Basic/Stateless

To start a stateless container:

```bash
docker run -it --rm onichandame/docker-dev
```

## Volume Mount

To access persistant storage on host:

```bash
docker run -it --rm -v <host path>:<container path> onichandame/docker-dev
```

## Port Mapping

To access server running in the container from host:

```bash
docker run -it --rm -p <host port>:<container port> onichandame/docker-dev
```
