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
- Neovim with coc.nvim and some coc extensions
- git(use env variables `GIT_USER_NAME` and `GIT_USER_EMAIL` to set the user info)
- EPICS base 3.15.8

# Usage

## Basic/Stateless

To start a stateless container:

```bash
docker run -it --rm onichandame/docker-dev -e GIT_USER_EMAIL=<your email in git commits> -e GIT_USER_NAME=<your name in git commits>
```

Pass `GIT_USER_NAME` and `GIT_USER_EMAIL` to set the git user info, which is required if you want to use `git commit`.

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

## Kubernetes

In case you want to develop in k8s environment, checkout the `kube` folder. There are a few points worth noticing:

1. To keep development files persistent, store the files on the host machine and map the directory to the containers using [StatefulSet](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/) and [PersistentVolume](https://kubernetes.io/docs/concepts/storage/persistent-volumes/).
2. To access a development server running in the container, use a service to expose the port to outside. Changing the port is cumbersome therefore the best practice is to expose certain ports once and for all. When developing the server, always point the server to the exposed ports.
3. The configuration in `kube` folder is finely tuned to match my own development environment. Read and change the yaml files before using it for your own development.
