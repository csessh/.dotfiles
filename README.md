# Dotfiles

Personal development configuration files managed with GNU Stow and Nix + home-manager.

`bootstrap.sh` sets up Fedora and Ubuntu **servers**. The workstation (`fw13`) runs **NixOS**, declared in `home-manager/.config/home-manager/nixos/` (see [NixOS Workstation](#nixos-workstation)).

## Quick Start

**One-liner** (on a fresh system):

```bash
git clone https://github.com/csessh/.dotfiles.git ~/.dotfiles && ~/.dotfiles/bootstrap.sh
```

**Or step by step:**

```bash
# Clone the repo (uses HTTPS for fresh systems without SSH keys)
git clone https://github.com/csessh/.dotfiles.git ~/.dotfiles

# Run bootstrap script
~/.dotfiles/bootstrap.sh
```

The bootstrap script will:

1. Upgrade system packages and install essentials (git, stow, curl, zsh)
2. Install Nix (Fedora: native package, others: official installer)
3. Enable flakes via stow
4. Install home-manager and apply the server configuration
5. Install system packages (Docker)
6. Add user to docker group
7. Install oh-my-zsh, remove stock .zshrc, stow shell config
8. Install TPM (Tmux Plugin Manager)
9. Stow configuration packages (git, nvim, tmux, bat, fastfetch)
10. Set zsh as default shell

Re-running it on an existing server is safe.

After bootstrap, log out and back in for all changes to take effect.

### Upgrading an existing server

Servers run nvim without LSP/completion/format/lint plugins (home-manager writes `~/.config/nvim-profile`). After pulling this change and re-running `bootstrap.sh` (or `home-manager switch --impure`), free the old plugins once:

```bash
nvim --headless "+Lazy! clean" +qa
rm -rf ~/.local/share/nvim/mason
```

## NixOS Workstation

The whole machine is declared in the flake: `nixosConfigurations.fw13` (system) with home-manager as a NixOS module (user). One rebuild applies both. `bootstrap.sh` detects NixOS and only does the user-level steps (oh-my-zsh, TPM, stow, bat cache).

### Install

1. Back up what isn't synced elsewhere (documents, unpushed repos, `~/.ssh`, `~/.gnupg`, Docker volumes). The NVMe is wiped, and the new home is `/home/tdo`.
2. In the firmware setup (F2), **disable Secure Boot**; the NixOS installer is not signed for it.
3. Write the graphical ISO to a USB stick (Fedora Media Writer, GNOME Disks "Restore Disk Image", or `dd`) and boot it. Any recent ISO works: the flake pins the exact nixpkgs. Already have a [test install on a stick](#test-on-a-usb-stick-first)? Boot that instead: it has the installer tools and every package in its store, so the install below barely downloads anything.
4. Partition, format and mount by hand (don't use the graphical installer's wizard: it runs a full install of its own). This **erases the disk**; check the device name with `lsblk` first:

   ```bash
   DISK=/dev/nvme0n1
   sudo parted "$DISK" -- mklabel gpt
   sudo parted "$DISK" -- mkpart ESP fat32 1MiB 1GiB
   sudo parted "$DISK" -- set 1 esp on
   sudo parted "$DISK" -- mkpart root btrfs 1GiB 100%
   sudo mkfs.fat -F 32 -n boot "${DISK}p1"
   sudo mkfs.btrfs -L nixos "${DISK}p2"

   sudo mount "${DISK}p2" /mnt
   sudo btrfs subvolume create /mnt/@
   sudo btrfs subvolume create /mnt/@home
   sudo umount /mnt
   sudo mount -o subvol=@ "${DISK}p2" /mnt
   sudo mkdir -p /mnt/home /mnt/boot
   sudo mount -o subvol=@home "${DISK}p2" /mnt/home
   sudo mount -o umask=0077 "${DISK}p1" /mnt/boot   # systemd-boot expects the ESP at /boot, not /boot/efi
   ```

   Then generate the hardware config (it records the subvolumes) and install from the repo:

   ```bash
   sudo nixos-generate-config --root /mnt
   sudo git clone https://github.com/csessh/.dotfiles.git /mnt/home/tdo/.dotfiles   # add -b exp/nixos until merged
   sudo cp /mnt/etc/nixos/hardware-configuration.nix \
      /mnt/home/tdo/.dotfiles/home-manager/.config/home-manager/nixos/
   cd /mnt/home/tdo/.dotfiles && sudo git add -A   # flakes only see tracked files
   sudo nixos-install --flake ./home-manager/.config/home-manager#fw13
   sudo nixos-enter --root /mnt -c 'passwd tdo'   # the config sets no user password
   ```

   No `git` on the ISO? Run `nix-shell -p git` first.

5. Reboot, log in, then:

   ```bash
   sudo chown -R tdo:users ~/.dotfiles
   ~/.dotfiles/bootstrap.sh       # then log out and back in
   fprintd-enroll                 # one or more fingers
   sudo -k && sudo true           # fingerprint or password
   sudo tailscale up
   ~/.dotfiles/tests/check.sh
   ```

6. Commit and push the generated `hardware-configuration.nix`, then switch the checkout to `main` once this branch is merged:

   ```bash
   cd ~/.dotfiles
   git remote set-url origin git@github.com:csessh/.dotfiles.git
   git add home-manager/.config/home-manager/nixos/hardware-configuration.nix
   git commit -m "nixos: fw13 hardware configuration" && git push
   ```

### Test on a USB stick first

The real config can run from a USB stick without touching the NVMe, which tests the hardware (fingerprint, Wi-Fi, suspend, Yubikey) before Fedora is wiped:

1. Run install step 4 from the current OS against the stick (`DISK=/dev/sdX`, partitions `1`/`2`; on a non-NixOS host get the tools with `nix shell nixpkgs#nixos-install-tools`), with two changes:
   - Install a host that extends `fw13` with `boot.loader.efi.canTouchEfiVariables = lib.mkForce false;`, so the laptop's boot order stays untouched, plus a temporary `users.users.tdo.initialPassword`.
   - Keep that host and the stick's `hardware-configuration.nix` on a local branch; neither belongs in `main`.
2. Boot the stick from the F12 menu, then run `bootstrap.sh` and `tests/check.sh`.

Expect USB 2.0 sticks to be slow (boot, first app launches, Mason installs). Hardware behaviour is what this test is for. The stick can then serve as the installer for the real install (step 3).

### Update and roll back

```bash
nix flake update --flake ~/.dotfiles/home-manager/.config/home-manager
sudo nixos-rebuild switch --flake ~/.dotfiles/home-manager/.config/home-manager#fw13

sudo nixos-rebuild switch --rollback   # or pick an older generation in the boot menu
```

Update regularly: every package, Chrome included, only moves when `flake.lock` does.

### Login and keys

- Login, lock screen and sudo accept the **fingerprint or password**. A fingerprint login leaves GNOME Keyring locked until its first use asks for the password.
- The **Yubikey** is for SSH only (PIV via opensc + the NixOS ssh-agent).

## Running the VM Tests

`tests/vm.sh` boots throwaway VMs, deploys the current working tree (including uncommitted changes) with `bootstrap.sh`, and runs `tests/check.sh` inside:

```bash
tests/vm.sh build    # build every flake config (seconds once cached)
tests/vm.sh ubuntu   # Ubuntu 24.04 server: bootstrap twice, then home-manager switch
tests/vm.sh nixos    # fw13 config in a build-vm VM: bootstrap twice
tests/vm.sh fedora   # Fedora 43 server (not part of `all`)
tests/vm.sh all      # build + ubuntu + nixos
```

Needs KVM, qemu and Nix. Images, logs and the throwaway SSH key live in `~/.cache/dotfiles-vm-tests` (set `DOTFILES_VM_CACHE` to move it; allow ~20 GB). `VM_KEEP=1` leaves the VM running after the test for debugging.

## Package Management

### Adding a new package

Edit `~/.dotfiles/home-manager/.config/home-manager/packages.nix`:

```nix
let
  basePackages = with pkgs; [
    # Packages for all hosts
    newpackage
  ];

  desktopPackages = with pkgs; [
    # Desktop-only packages
    gui-app
  ];
in { ... }
```

Then apply:

```bash
home-manager switch --impure
```

### Updating packages

```bash
# Update flake inputs (gets latest nixpkgs)
nix flake update ~/.config/home-manager

# Apply updates
home-manager switch --impure
```

### Garbage collection

```bash
# Remove old generations
nix-collect-garbage -d
```

### Rollback

```bash
# List previous generations
home-manager generations

# Roll back to previous generation
home-manager switch --rollback
```

## Configuration Management

Configurations are managed with GNU Stow. Each tool has its own directory that mirrors the target filesystem structure.

```bash
cd ~/.dotfiles

# Deploy a config
stow nvim

# Remove a config
stow -D nvim

# Restow (remove then deploy)
stow -R nvim
```

## Stow Packages

| Package | Description | Workstation Only |
|---------|-------------|--------------|
| [bat](./bat/README.md) | cat replacement with syntax highlighting | |
| [claude](./claude/README.md) | Claude Code global instructions and statusline | Yes |
| [fastfetch](./fastfetch/README.md) | system information tool | |
| [ghostty](./ghostty/README.md) | terminal emulator | Yes |
| [git](./git/README.md) | git and lazygit configuration | |
| [nvim](./nvim/README.md) | neovim configuration | |
| [shell](./shell/README.md) | zsh configuration (requires oh-my-zsh) | |
| [ssh](./ssh/README.md) | SSH configuration | Yes |
| [tmux](./tmux/README.md) | tmux configuration | |

## What's Managed Where

| Component | Manager | Notes |
|-----------|---------|-------|
| CLI tools (ripgrep, fd, fzf, bat, etc.) | Nix | Declarative, reproducible |
| Dev tools (neovim, tmux, git) | Nix | Same versions across machines |
| Languages (nodejs, python, go) | Nix | Consistent toolchain |
| Docker | System (dnf/apt) | System integration |
| oh-my-zsh | curl installer | Shell framework |
| Configs | Stow | Symlinked from dotfiles |
