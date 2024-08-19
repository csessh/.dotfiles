# 1Password

## Pre-requisites

- [Stow](https://www.gnu.org/software/stow/) is installed.
- [1Password](https://1password.com/) is installed.

## Installation

### 1Password CLI

There is an [official guide](https://developer.1password.com/docs/cli/get-started/) for this.

### agent.toml 

```bash
stow 1password
```

A symlink to `agent.toml` should now be created and placed under `~/.config` directory:

```bash
ls -la ~/.config/1Password/ssh/          

total 8
drwx------. 1 csessh csessh  48 Aug 17 12:02 .
drwx------. 1 csessh csessh 614 Aug 18 12:49 ..
lrwxrwxrwx. 1 csessh csessh  61 Aug 17 12:02 agent.toml -> ../../../.dotfiles/1password/.config/1Password/ssh/agent.toml
```

Simple enough. 
