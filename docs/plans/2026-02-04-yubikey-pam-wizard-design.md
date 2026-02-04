# YubiKey PAM Setup Wizard Design

## Overview

A guided setup script for configuring YubiKey FIDO2 PAM authentication (login/sudo). The script lives at `~/.dotfiles/setup-yubikey-pam.sh` and is referenced by bootstrap for desktop hosts.

## Flow

```
Pre-flight checks → FIDO2 PIN (skip) → Key registration → PAM config → Fingerprint (optional) → Summary
```

## Pre-flight Checks

- Verify YubiKey inserted via `ykman info`
- Verify `pamu2fcfg` available (Nix-installed)
- Warn if `~/.config/Yubico/u2f_keys` exists, offer to overwrite

## FIDO2 PIN Setup

- Offer to set/change PIN via `ykman fido access change-pin`
- Skippable if already configured

## Key Registration

- Create `~/.config/Yubico/` directory
- Run `pamu2fcfg > ~/.config/Yubico/u2f_keys` for primary key
- Loop to register additional backup keys (append with `>>`)

## PAM Configuration

User selects which files to configure:

| File | Purpose |
|------|---------|
| `/etc/pam.d/sudo` | Terminal sudo |
| `/etc/pam.d/gdm-password` | GDM login |
| `/etc/pam.d/gdm-fingerprint` | GDM fingerprint prompt |

For each selected file:

1. Backup to `<file>.yubikey-backup`
2. Insert `auth required pam_u2f.so cue pinverification=1` at top
3. Prompt user to test in new terminal
4. If test fails, restore from backup immediately

## Fingerprint Disable (Optional)

- Offer `sudo systemctl mask fprintd.service`
- Prevents fingerprint from bypassing YubiKey at GDM

## Summary

- List configured files
- List backup locations
- Print recovery instructions (live USB mount and restore)

## Bootstrap Integration

Add to `main()` after completion message (desktop only):

```bash
if [ "$HOST_TYPE" = "desktop" ]; then
    echo ""
    info "Optional: Configure YubiKey PAM authentication (login/sudo)"
    echo "  Run: ~/.dotfiles/setup-yubikey-pam.sh"
fi
```

## Files to Create/Modify

| File | Action |
|------|--------|
| `setup-yubikey-pam.sh` | Create (new script) |
| `bootstrap.sh` | Add reference message |
