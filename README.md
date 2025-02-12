# Dotfiles

This repo contains my own dev configuration files, a.k.a dotfiles.
The configurations are managed with GNU Stow, and automated with Ansible

This playbook currently supports Fedora. Ubuntu and MacOS playbooks are in the work.

## Ansible

### Pre-requisites

Ansible is able to automate 99% of the process, however it does require the following packages to be present:

- Python3
- pip
- [Ansible](https://docs.ansible.com/ansible/latest/index.html)

Note: 9 out of 10 times, Python and pip are shipped out of the box with a Linux distro.

Ansible must be installed manually.

``` bash
sudo dnf install ansible
```

### dotfiles playbook

``` bash
cd ~/.dotfiles/ansible
bin/install
```

## dotfiles

For more details, refer to each package's README.md:

- [1Password](./1password/README.md)
- [kitty](./kitty/README.md)
- [neovim](./nvim/README.md)
- [bat](./bat/README.md)
- [git](./git/README.md)
- [htop](./htop/README.md)
- [lazygit](./lazygit/README.md)
- [pet](./pet/README.md)
- [tmux](./tmux/README.md)
- [zsh](./shell/README.md)
