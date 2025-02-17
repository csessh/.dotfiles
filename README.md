# Dotfiles

This repo contains my own dev configuration files, a.k.a dotfiles.
The configurations are managed with GNU Stow, and automated with Ansible

This playbook currently supports Fedora. Ubuntu and MacOS playbooks are in the work.

## Ansible

### Pre-requisites

Ansible is able to automate 99% of the process, however it does require the following packages to be present:

- Python3 and pip
- [Ansible](https://docs.ansible.com/ansible/latest/index.html)

Note: 9 out of 10 times, Python and pip are shipped out of the box with a Linux distro.

To install Ansible:

``` bash
sudo dnf install ansible
```

### dotfiles playbook

As `ansible.cfg` and `inventory` are placed under `ansible/` directory, the execution of the the playbook will need to be from this directory:

``` bash
cd ~/.dotfiles/ansiblehttps://github.com/zapling/mason-conform.nvim?tab=readme-ov-file#setup
```

### Running the playbook locally

If there is a `vault` file present (ignored by `.gitignore`):

``` bash
ansible-playbook dotfiles.yml --become-pass-file vaut --vault-pass-file vaut
```

Otherwise, specify passwords at prompts:

``` bash
ansible-playbook dotfiles.yml --ask-become-pass --ask-vault-pass
```

### Running the playbook remotely

Current, some very minor modification of [inventory](./ansible/inventory) and [dotfiles.yml](./ansible/dotfiles.yml) is required.

``` ini
[local]
localhost

[local:vars]
ansible_connection=local

[remotes]
x.x.x.x

```

``` yml

- name: The "I-specialise-in-automation" dotfiles playbook
  hosts: remotes
  roles:
    # Standard tools/packages
    - utils
    ...
```

Finally, execute playbook in remote servers:

``` bash
ansible-playbook dotfiles.yml
```

*Note*: Unless remote hosts are part of long term workflow, don't commit their IP addresses to Git repo.

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
