# YubiKey PAM Authentication for Fedora

Replace password authentication with YubiKey (FIDO2 PIN + touch) for login and sudo.

## Prerequisites

- YubiKey 5 series (or any FIDO2-capable key)
- FIDO2 PIN set on the YubiKey
- Fedora Workstation (tested on Fedora with GDM)

## Installation

```bash
sudo dnf install pam-u2f pamu2fcfg
```

## Set FIDO2 PIN (if not already set)

```bash
ykman fido access change-pin
```

Or use Yubico Authenticator app.

## Register YubiKey

```bash
mkdir -p ~/.config/Yubico
pamu2fcfg > ~/.config/Yubico/u2f_keys
```

Touch the key when it blinks.

### Add backup key

```bash
pamu2fcfg >> ~/.config/Yubico/u2f_keys
```

### Stow

Both keys have been registered and stored in this directory.

```bash
cd ~/.dotfiles
stow Yubico
```

## PAM Configuration

Add the following line at the top of each file, before other `auth` lines.

```
auth required pam_u2f.so cue pinverification=1
```

At the same time, disable (commenting out) any other `auth` lines below this to enforce strict Yubikey authentication with no password fallback.

### Files to edit

| File | Purpose |
|------|---------|
| `/etc/pam.d/gdm-password` | GDM login screen |
| `/etc/pam.d/gdm-fingerprint` | GDM fingerprint prompt (if triggered) |
| `/etc/pam.d/sudo` | Terminal sudo |

### Example `/etc/pam.d/sudo`

```
auth required pam_u2f.so cue pinverification=1

account include system-auth
password include system-auth
session include system-auth
```

## Disable Fingerprint Reader

```bash
sudo systemctl mask fprintd.service
```

To re-enable later:

```bash
sudo systemctl unmask fprintd.service
```

## Testing

**Keep a root shell open while testing:**

```bash
sudo -i
```

In another terminal:

```bash
sudo whoami
```

Should prompt for YubiKey PIN + touch only.

## Recovery

If locked out:

1. Boot from live USB
2. Mount root filesystem
3. Revert PAM changes or unmask fprintd

## Options Reference

| PAM option | Effect |
|------------|--------|
| `cue` | Shows "Please touch the device" prompt |
| `pinverification=1` | Requires FIDO2 PIN |
| `required` | Must succeed, no fallback |
| `sufficient` | If succeeds, skip remaining auth (allows fallback) |
