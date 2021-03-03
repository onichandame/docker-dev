# docker-dev

docker images for development environment.

# Author

[onichandame](https://github.com/onichandame)

# Core Features

- Common CLI tools
- Common development tools
- Neovim with coc.nvim and some coc extensions
- git(use env variables `GIT_USER_NAME` and `GIT_USER_EMAIL` to set the user info)

# Use Cases

## Docker Engine/Desktop

To start a stateless container:

```bash
docker run -it --rm onichandame/docker-dev -e GIT_USER_EMAIL=<your email in git commits> -e GIT_USER_NAME=<your name in git commits> -v <host path>:<container path> -p <host port>:<container port>
```

Pass `GIT_USER_NAME` and `GIT_USER_EMAIL` to set the git user info, which is required if you want to use `git commit`.

## Kubernetes

In case you want to develop in k8s environment, checkout the `kube` folder and modify the configurations based on your needs. There are a few points worth noticing:

1. To keep files persistent, store the files on the host machine and map the directory to the containers using [StatefulSet](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/) and [PersistentVolume](https://kubernetes.io/docs/concepts/storage/persistent-volumes/).
2. To access a server running in the container, use a service to expose the port to outside. Changing the port is cumbersome therefore the best practice is to expose certain ports once and for all. When developing apps, always point the development servers to the exposed ports.
3. The configuration in `kube` folder is somewhat biased to match my own needs. **Read and change the yaml files** before using it for your own development.

# Configuration

All configurations are passed in as environmental variables.

| variable name | description                                |
| ------------- | ------------------------------------------ |
| DIND_ENABLED  | start dind daemon when set                 |
| SSHD_ENABLED  | start sshd daemon when set                 |
| SSH_KEYS      | ssh keys separated by semicolon            |
| IPFS_ENABLED  | start ipfs node when set                   |
| DIND_ARGS     | pass CLI args to dind                      |
| NPM_REGISTRY  | name or url of the npm registry being used |
| NPM_USERNAME  | username of npm user                       |
| NPM_PASSWORD  | password of npm user                       |
| NPM_EMAIL     | email of npm user                          |
