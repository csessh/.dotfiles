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
cd ~/.dotfiles/ansible
```

### Running the playbook locally

If there is a `vault` file present (ignored by `.gitignore`):

``` bash
ansible-playbook localhost.yml --become-pass-file vaut --vault-pass-file vaut
```

Otherwise, specify passwords at prompts:

``` bash
ansible-playbook localhost.yml --ask-become-pass --ask-vault-pass
```

### Running the playbook on remote servers

``` bash
ansible-playbook remote.yml -i <address> remote.yml
```
