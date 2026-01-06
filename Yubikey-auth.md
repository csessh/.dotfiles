# YubiKey PAM Authentication for Fedora

Replace password authentication with YubiKey (FIDO2 PIN + touch) for login and sudo.

## Quick Start

```bash
# 1. Install
sudo dnf install pam-u2f pamu2fcfg

# 2. Set FIDO2 PIN (if not already set)
ykman fido access change-pin

# 3. Register primary key
mkdir -p ~/.config/Yubico
pamu2fcfg > ~/.config/Yubico/u2f_keys

# 4. Register backup key (optional)
pamu2fcfg >> ~/.config/Yubico/u2f_keys

# 5. Configure PAM - add to top of /etc/pam.d/{gdm-password,gdm-fingerprint,sudo}
auth required pam_u2f.so cue pinverification=1

# 6. Disable fingerprint reader (optional)
sudo systemctl mask fprintd.service
```

---

## Prerequisites

- YubiKey 5 series or any FIDO2-capable key
- Fedora Workstation (tested with GDM)

## Registration

Run `pamu2fcfg` and touch the key when it blinks. The command outputs a credential line stored in `~/.config/Yubico/u2f_keys`.

For backup keys, append (`>>`) to the same file.

## PAM Configuration

Add the auth line at the top of each PAM file, before other `auth` lines. Comment out existing `auth` lines to enforce strict YubiKey authentication with no password fallback.

### Files to edit

| File | Purpose |
|------|---------|
| `/etc/pam.d/gdm-password` | GDM login screen |
| `/etc/pam.d/gdm-fingerprint` | GDM fingerprint prompt |
| `/etc/pam.d/sudo` | Terminal sudo |

### Example `/etc/pam.d/sudo`

```
auth required pam_u2f.so cue pinverification=1

account include system-auth
password include system-auth
session include system-auth
```

## Testing

Keep a root shell open (`sudo -i`) while testing. In another terminal, run `sudo whoami` — should prompt for YubiKey PIN + touch only.

## Recovery

If locked out:

1. Boot from live USB
2. Mount root filesystem
3. Revert PAM changes or unmask fprintd

## PAM Options Reference

| Option | Effect |
|--------|--------|
| `cue` | Shows "Please touch the device" prompt |
| `pinverification=1` | Requires FIDO2 PIN |
| `required` | Must succeed, no fallback |
| `sufficient` | If succeeds, skip remaining auth (allows fallback) |
