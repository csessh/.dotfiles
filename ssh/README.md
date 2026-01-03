# SSH configuration

## Cloudflared + Yubikey

This is a particular setup to connect home server. It required cloudflared tunnel and one of my Yubikeys to authenticate.

```bash
ssh-keygen -K
```

This extracts resident SSH keys from the YubiKey. We'll get files like:

```bash
id_ed25519_sk_rk_<key_handle> (private key handle)
id_ed25519_sk_rk_<key_handle>.pub (public key)
```

Rename them to match the Yubikey's name. e.g. nano or nfc.

```bash
mv nano ~/.ssh/
chmod 600 ~/.ssh/nano
```

## 1Password ssh agent

Most ssh keys are managed by [1Password ssh agent](https://developer.1password.com/docs/ssh/agent).

## Configuration

```bash
cd ~/.dotfiles
stow ssh
```
