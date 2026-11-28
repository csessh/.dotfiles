# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

Personal dotfiles managed with GNU Stow and Nix home-manager. `bootstrap.sh` sets up Fedora and Ubuntu **servers**, and on NixOS runs only the user-level steps.

Indentation (`.editorconfig`): 2 spaces, 4 for `*.sh` and `*.md`.

## Architecture

**Two-layer management:**
1. **Nix home-manager** - Installs packages declaratively (CLI tools, dev tools, languages)
2. **GNU Stow** - Symlinks configuration files from dotfiles to home directory

**Hosts:**
- **Workstation (`fw13`)**: NixOS. `nixosConfigurations.fw13` in the flake, system config in `home-manager/.config/home-manager/nixos/`, home-manager runs as a NixOS module importing `home/common.nix` + `home/desktop.nix`. `bootstrap.sh` only does user-level steps there (oh-my-zsh, TPM, stow incl. ghostty/ssh/claude, bat cache).
- **Servers (Fedora/Ubuntu)**: standalone home-manager (`linux-server`, `linux-arm-server`, or the `$USER` default) importing `home/common.nix` + `home/server.nix`, nvim server profile via `~/.config/nvim-profile`.

**Why `--impure` flag**: The server configs read `$USER` and `$HOME` at runtime. `nixosConfigurations.fw13` is pure.

**Flake files** (`home-manager/.config/home-manager/`):
- `flake.nix`: inputs and host wiring only. Which `home/` modules a host imports decides its profile; there is no desktop flag.
- `overlays.nix`: custom packages from `pkgs/` (lsoff, obel-mono) plus individual nixos-unstable swaps (servers and fw13). Drop an unstable override once stable catches up.
- `home/common.nix`: all hosts. Packages, version assertions, stateVersion.
- `home/server.nix`: servers only. Writes `~/.config/nvim-profile`, refuses to switch over an old `host-type=desktop`.
- `home/desktop.nix`: fw13 only. Desktop packages and GUI apps, fonts, GNOME `dconf.settings` (input sources, idle/suspend), opensc symlink.
- `nixos/configuration.nix`: system level for fw13, in sections (boot & hardware, networking, locale, user & shell, development, nix, VM test). `nixos/system-integrated-application.nix`: apps needing system integration (1Password polkit/setgid helper, LocalSend firewall). `nixos/gnome.nix`: GNOME/GDM, ibus, logind lid. `nixos/yubikey.nix`: pcscd + ssh-agent PKCS#11.
- Package placement: `configuration.nix` only for things needing a service, firewall, polkit, setuid or root (prefer `programs.*.enable`); everything else in `home/`.

**Native package manager exception**: on servers Docker comes from dnf/apt for system integration (fw13 uses `virtualisation.docker`). Fedora's Nix itself comes from dnf, so it has no `/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh`; guard any sourcing of it.

**Stow packages**: bat, claude (workstation), fastfetch, ghostty (workstation), git, home-manager (servers), lazygit, nix (servers), nvim, shell, ssh (workstation), tmux

**Flake location**: servers stow `home-manager`, so the flake is at `~/.config/home-manager`. The workstation does not stow it (`~/.config/home-manager` does not exist there); `nixos-rebuild` reads the flake directly from `~/.dotfiles/home-manager/.config/home-manager`.

**Bootstrap order**: system upgrade → essentials → dotfiles clone → nix → stow nix config → stow home-manager → home-manager switch → Docker → docker group → oh-my-zsh → TPM → stow remaining configs → bat cache → zsh as login shell. Safe to re-run.

**Key directories**:
- `home-manager/.config/home-manager/` - Nix flake and package definitions
- `<package>/.config/<app>/` - Standard XDG config structure (stow deploys to ~/.config/)

**Version requirements** (`home/common.nix` assertions): fzf 0.67+, neovim 0.11+, lua 5.4+

**Theme**: Cyberdream across nvim, bat, git-delta, tmux, and terminal emulators.

## Common Commands

### Bootstrap (fresh system)
```bash
git clone https://github.com/csessh/.dotfiles.git ~/.dotfiles && ~/.dotfiles/bootstrap.sh
```

### Nix Package Management (servers)
On the workstation, edit the same `home/` files and apply with `nixos-rebuild` (see NixOS Workstation below).
```bash
# Add package (under home-manager/.config/home-manager/):
# - home/common.nix: all hosts
# - home/desktop.nix: workstation only
home-manager switch --impure
nix fmt   # nixpkgs-fmt over the flake

# Update all packages
nix flake update ~/.config/home-manager && home-manager switch --impure

# Rollback
home-manager generations  # list
home-manager switch --rollback

# Garbage collection
nix-collect-garbage -d
```

### NixOS Workstation
```bash
sudo nixos-rebuild switch --flake ~/.dotfiles/home-manager/.config/home-manager#fw13
nix flake update --flake ~/.dotfiles/home-manager/.config/home-manager   # then rebuild
sudo nixos-rebuild switch --rollback
```

### VM Tests
```bash
tests/vm.sh all        # build + ubuntu + nixos; also: build | ubuntu | fedora | nixos
VM_KEEP=1 tests/vm.sh ubuntu   # keep the VM for debugging
```
`build` only nix-builds `linux-server` and `fw13` (no VM), the quick check after flake edits. Fedora is opt-in, not part of `all`. Each OS stage runs `bootstrap.sh` twice (idempotency), then a plain `home-manager switch --impure`, then checks that the switch refuses `host-type=desktop`. `tests/check.sh` runs after each round; it has no single-check flag and picks its checks by host type (servers: server nvim profile, no Mason, untouched repo lockfile; NixOS: apps on PATH, pcscd, tailscale, ssh-agent, fingerprint PAM, Mason binaries).

- VMs need `qemu` and `cloud-utils` (in `home/desktop.nix`). From inside Claude Code, prefix `env -u LD_LIBRARY_PATH`: the claude-code wrapper exports an unstable alsa-lib that crashes 26.05 qemu (`GLIBC_2.43 not found`).
- The tests snapshot the working tree (tracked + untracked), so uncommitted work is tested. Nix itself only sees files Git tracks: `git add` new or renamed files before any build.
- Pure refactors: compare `nix eval --impure --raw .#<output>.drvPath` before and after; identical paths mean no behaviour change.

### GNU Stow
```bash
stow nvim       # Deploy
stow -D nvim    # Remove
stow -R nvim    # Restow
```

## Neovim

**Server profile**: LSP, completion, format and lint plugins, plus neo-tree, markdown rendering, helpview and scratch, live in `lua/plugins/dev/`. `init.lua` skips that folder when `~/.config/nvim-profile` reads `server`, which the server home-manager config writes; the workstation loads everything. A file rather than an env var so nvim launched outside zsh gets it too. Servers keep lazy.nvim's lockfile in `stdpath("data")`, seeded from the repo's `lazy-lock.json`, so only the workstation updates the tracked lockfile.

LSP, formatter and linter binaries come from Mason, not Nix. `lua/plugins/archived/` is not imported.

**LSP Servers** (dev/lsp.lua): bashls, clangd, docker_compose_language_service, dockerls, gopls, lua_ls (Love2D), markdown_oxide, nil_ls (nix), pyright, ruff, taplo, ts_ls

**Formatters** (dev/conform.lua): stylua (Lua), nixpkgs_fmt (Nix), ruff_format + ruff_organize_imports (Python), eslint_d (.ts files only). Format-on-save with 500ms timeout.

**Linters** (dev/linters.lua): bash→shellcheck, cpp→cpplint, json→jsonlint, python→ruff, yaml→yamllint

**Key bindings**: `<leader>ca` code actions, `<leader>fm` format, `<leader>rn` rename

## Tmux

Prefix: `C-Space`

- `<prefix>hjkl` select pane, `<prefix>HJKL` swap pane
- `M-hjkl` resize (no prefix)
- `<prefix>s` horizontal split, `<prefix>v` vertical split
- `<prefix>r` reload config
- `<prefix><C-s>` save session, `<prefix><C-r>` restore (tmux-resurrect)
- `<prefix>Enter` toggle synchronize-panes
- `<C-h/j/k/l>` seamless nvim-tmux navigation

## Shell (zsh)

Uses zinit for plugins (zsh-syntax-highlighting, zsh-completions, zsh-autosuggestions) and oh-my-zsh framework. The `cd` command is zoxide (smart directory jumper).

**Yubikey PIV**: On shell startup, `.zshrc` loads the Yubikey PIV key into ssh-agent via `ssh-add -s` unless it is already loaded. The opensc library is linked at `~/.local/lib/opensc-pkcs11.so` on the workstation. The agent logs into the card once; if pcscd restarts or the card resets, signing fails with `C_Sign failed: 5` / "agent refused operation" until `piv` reloads the key. `nixos/yubikey.nix` sets `pcscd.restartIfChanged = false` so `nixos-rebuild switch` does not cause that.

**Aliases**: `cat`→bat, `vim`/`v`→nvim, `lazy`→lazygit, `tmx`→tmux, `stwo`→stow, `dps`→dockerps, `wscat`→websocat, `tree`→`tree -Cap -I .git`

**Functions** (scripts.zsh): `box A|B|F|P` look up an EC2 box by name, `nah [-f]` git reset, `snipe` kill process via fzf, `piv` restart ssh-agent and reload the PIV key, `zeload` reload zshrc, `mkd` mkdir+cd, `paths` list PATH, `dockerps` formatted docker ps, `filesize` sorted file sizes, `today` current date, `trim` strip whitespace, `rgrep` recursive grep

**Keybindings**: `Ctrl+P/N` history search, `Ctrl+Z` fg
