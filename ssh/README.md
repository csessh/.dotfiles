# ssh

SSH client configuration (workstation only).

## Configuration

```bash
cd ~/.dotfiles
stow ssh
```

`bootstrap.sh` creates `~/.ssh` (mode 700) first, so stow links the file into it instead of folding the directory into this repo.

## SSH Config

- **AddKeysToAgent**: yes (auto-add keys on first use)
- **ForwardAgent**: yes (forward agent to remote hosts)

## Yubikey PIV

NixOS runs the agent (`programs.ssh.startAgent`, PKCS#11 whitelist `/nix/store/*`) and `pcscd`; GNOME's gcr agent is disabled because it lacks PKCS#11 support. home-manager links opensc at `~/.local/lib/opensc-pkcs11.so`, and `.zshrc` runs `ssh-add -s` with it when the Yubikey is plugged in and its key is not loaded yet.
