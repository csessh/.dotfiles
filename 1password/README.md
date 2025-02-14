# 1Password

## SSH Agent

As per [Official documentation from 1Password](https://developer.1password.com/docs/ssh/agent/):

> The 1Password SSH agent uses the SSH keys you have saved in 1Password to seamlessly integrate with your Git and SSH workflows. It authenticates your Git and SSH clients without those clients ever being able to read your private key.

> In fact, your private key never even leaves the 1Password app. The SSH agent works with the SSH keys stored in 1Password, but never without your consent. Only SSH clients you explicitly authorize will be able to use your SSH keys until 1Password locks.

*Notes*:

This setup works great for personal use, but I'd be more a little careful with this setup in a professional setting.

## Configuration

```bash
cd ~/.dotfiles
stow 1password
```
