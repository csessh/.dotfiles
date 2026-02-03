# YubiKey PAM Authentication for macOS

Replace password authentication with YubiKey (FIDO2 PIN + touch) for sudo.

## Quick Start

```bash
# 1. Install (via Homebrew - pamu2fcfg not reliably available in Nix on macOS)
brew install pam-u2f

# 2. Set FIDO2 PIN (if not already set)
ykman fido access change-pin

# 3. Register primary key
mkdir -p ~/.config/Yubico
pamu2fcfg > ~/.config/Yubico/u2f_keys

# 4. Register backup key (optional)
pamu2fcfg >> ~/.config/Yubico/u2f_keys

# 5. Configure PAM - edit /etc/pam.d/sudo
sudo nano /etc/pam.d/sudo
# Add at top: auth sufficient pam_u2f.so

# 6. Test in new terminal
sudo whoami
```

---

## Prerequisites

- YubiKey 5 series or any FIDO2-capable key
- macOS (tested on Sonoma/Sequoia)
- Homebrew installed
- `yubikey-manager` installed (via Nix home-manager or `brew install ykman`)

## Registration

Run `pamu2fcfg` and touch the key when it blinks. The command outputs a credential line stored in `~/.config/Yubico/u2f_keys`.

For backup keys, append (`>>`) to the same file.

## PAM Configuration

Add the auth line at the top of the PAM file, before other `auth` lines.

### Example `/etc/pam.d/sudo`

**YubiKey only (no fallback):**
```
auth       required       pam_u2f.so cue
account    required       pam_permit.so
password   required       pam_deny.so
session    required       pam_permit.so
```

**YubiKey with password fallback:**
```
auth       sufficient     pam_u2f.so cue
auth       required       pam_opendirectory.so
account    required       pam_permit.so
password   required       pam_deny.so
session    required       pam_permit.so
```

**Touch ID + YubiKey + password fallback:**
```
auth       sufficient     pam_tid.so
auth       sufficient     pam_u2f.so cue
auth       required       pam_opendirectory.so
account    required       pam_permit.so
password   required       pam_deny.so
session    required       pam_permit.so
```

## Testing

Keep a root shell open (`sudo -s`) while testing. In another terminal, run `sudo whoami` — should prompt for YubiKey touch (and PIN if configured).

## Recovery

If locked out:

1. Boot into Recovery Mode (hold Command+R on Intel, or power button on Apple Silicon)
2. Open Terminal from Utilities menu
3. Mount your main volume: `diskutil mount /dev/disk1s1` (adjust as needed)
4. Edit PAM file: `nano /Volumes/Macintosh\ HD/etc/pam.d/sudo`
5. Remove or comment out the `pam_u2f.so` line
6. Reboot normally

## PAM Options Reference

| Option | Effect |
|--------|--------|
| `cue` | Shows "Please touch the device" prompt |
| `pinverification=1` | Requires FIDO2 PIN (may not work on all macOS versions) |
| `required` | Must succeed, no fallback |
| `sufficient` | If succeeds, skip remaining auth (allows fallback) |

## macOS-Specific Notes

- **System updates may reset PAM**: Major macOS updates can overwrite `/etc/pam.d/sudo`. Re-apply configuration after updates.
- **Touch ID integration**: macOS has native `pam_tid.so` for Touch ID. You can combine both for maximum flexibility.
- **No login screen support**: Unlike Linux/GDM, macOS login screen doesn't support pam_u2f. YubiKey auth is primarily for sudo/terminal.
- **Screen unlock**: Consider using YubiKey with macOS's built-in smart card support for screen unlock instead of PAM.

## Differences from Linux/Fedora

| Aspect | Fedora | macOS |
|--------|--------|-------|
| Package manager | `dnf install pam-u2f` | `brew install pam-u2f` |
| Login screen | GDM supports pam_u2f | Not supported |
| Base PAM module | `pam_unix.so` / `system-auth` | `pam_opendirectory.so` |
| Touch ID equivalent | Fingerprint via fprintd | `pam_tid.so` |
| Recovery | Live USB | Recovery Mode |
