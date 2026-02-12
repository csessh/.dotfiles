# ssh

SSH client configuration and ssh-agent systemd service.

## Configuration

```bash
cd ~/.dotfiles
stow ssh
```

## Structure

```
ssh/
├── .ssh/
│   └── config              # SSH client config
└── .config/systemd/user/
    └── ssh-agent.service   # User systemd service
```

## SSH Config

- **AddKeysToAgent**: yes (auto-add keys on first use)
- **ForwardAgent**: yes (forward agent to remote hosts)

### Cloudflared Tunnel

Connection to home server via Cloudflare tunnel:
```
Host console.tdo.io.vn
    User tdo
    ProxyCommand cloudflared access ssh --hostname console.tdo.io.vn
```

Requires `cloudflared` client installed (via Nix home-manager).

## SSH Agent Service

Systemd user service for OpenSSH agent with PKCS#11 support:

```bash
# Enable and start
systemctl --user enable ssh-agent
systemctl --user start ssh-agent
```

The service configures PKCS#11 provider whitelist (OpenSSH 8.9+) for:
- System libs (`/usr/lib*/*`)
- Nix store (`/nix/store/*/lib/*`)
- User local lib (`~/.local/lib/*`)

## Yubikey PIV Integration

The ssh-agent service works with `.zshrc` to load Yubikey PIV keys:
1. Service starts with PKCS#11 whitelist
2. Shell startup runs `ssh-add -s` with opensc library
3. PIV key is available for SSH authentication

**Note**: opensc is installed via native package manager (dnf/apt) for ABI compatibility with system openssh.
