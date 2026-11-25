# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

Personal dotfiles managed with GNU Stow and Nix home-manager. `bootstrap.sh` sets up Fedora and Ubuntu **servers**.

## Architecture

**Two-layer management:**
1. **Nix home-manager** - Installs packages declaratively (CLI tools, dev tools, languages)
2. **GNU Stow** - Symlinks configuration files from dotfiles to home directory

**Hosts:**
- **Workstation (`fw13`)**: NixOS. `nixosConfigurations.fw13` in the flake, system config in `home-manager/.config/home-manager/nixos/`, home-manager runs as a NixOS module with `desktopEnabled = true`. `bootstrap.sh` only does user-level steps there (oh-my-zsh, TPM, stow incl. ghostty/ssh/claude, bat cache).
- **Servers (Fedora/Ubuntu)**: standalone home-manager (`linux-server`, `linux-arm-server`, or the `$USER` default), `basePackages` only, nvim server profile via `~/.config/nvim-profile`.

**Why `--impure` flag**: The server configs read `$USER` and `$HOME` at runtime. `nixosConfigurations.fw13` is pure.

**Flake files** (`home-manager/.config/home-manager/`):
- `flake.nix`: `unstableOverlay` swaps individual packages for their nixos-unstable versions (servers and fw13). Drop an override once stable catches up.
- `packages.nix`: `basePackages` everywhere, `desktopPackages` only when `desktopEnabled`.
- `home.nix`: `desktopEnabled` also gates GNOME `dconf.settings` (keyboard input sources etc.) and fonts; when false it writes `~/.config/nvim-profile`.
- `nixos/configuration.nix`: system level for fw13 (GNOME/GDM, ibus input method, fprintd, PIV).

**Native package manager exception**: Docker is installed via dnf/apt for system integration.

**Stow packages**: bat, claude (workstation), fastfetch, ghostty (workstation), git, home-manager (servers), lazygit, nix (servers), nvim, shell, ssh (workstation), tmux

**Flake location**: servers stow `home-manager`, so the flake is at `~/.config/home-manager`. The workstation does not stow it (`~/.config/home-manager` does not exist there); `nixos-rebuild` reads the flake directly from `~/.dotfiles/home-manager/.config/home-manager`.

**Bootstrap order**: system upgrade → essentials → dotfiles clone → nix → stow nix config → stow home-manager → home-manager switch → Docker → docker group → oh-my-zsh → TPM → stow remaining configs → bat cache → zsh as login shell. Safe to re-run.

**Key directories**:
- `home-manager/.config/home-manager/` - Nix flake and package definitions
- `<package>/.config/<app>/` - Standard XDG config structure (stow deploys to ~/.config/)

**Version requirements** (packages.nix assertions): fzf 0.67+, neovim 0.11+, lua 5.4+

**Theme**: Cyberdream across nvim, bat, git-delta, tmux, and terminal emulators.

## Common Commands

### Bootstrap (fresh system)
```bash
git clone https://github.com/csessh/.dotfiles.git ~/.dotfiles && ~/.dotfiles/bootstrap.sh
```

### Nix Package Management (servers)
On the workstation, edit the same `packages.nix` and apply with `nixos-rebuild` (see NixOS Workstation below).
```bash
# Add package: edit home-manager/.config/home-manager/packages.nix
# - basePackages: all hosts
# - desktopPackages: workstation only
home-manager switch --impure

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
`build` only nix-builds `linux-server` and `fw13` (no VM), the quick check after flake edits. Fedora is opt-in, not part of `all`. Inside each VM, `tests/check.sh` runs the assertions.
New files must be `git add`ed before nix sees them.

### GNU Stow
```bash
stow nvim       # Deploy
stow -D nvim    # Remove
stow -R nvim    # Restow
```

## Neovim

**Server profile**: LSP, completion, format and lint plugins, plus neo-tree, markdown rendering, helpview and scratch, live in `lua/plugins/dev/`. `init.lua` skips that folder when `~/.config/nvim-profile` reads `server`, which the server home-manager config writes; the workstation loads everything. A file rather than an env var so nvim launched outside zsh gets it too. Servers keep lazy.nvim's lockfile in `stdpath("data")`, seeded from the repo's `lazy-lock.json`, so only the workstation updates the tracked lockfile.

LSP, formatter and linter binaries come from Mason, not Nix. `lua/plugins/archived/` is not imported.

**LSP Servers** (dev/lsp.lua): bashls, clangd, docker_compose_language_service, dockerls, lua_ls (Love2D), markdown_oxide, pyright, ruff, taplo, ts_ls

**Formatters** (dev/conform.lua): stylua (Lua), ruff_format + ruff_organize_imports (Python), eslint_d (.ts files only). Format-on-save with 500ms timeout.

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

**Yubikey PIV**: On shell startup, `.zshrc` loads the Yubikey PIV key into ssh-agent via `ssh-add -s`. The opensc library is linked at `~/.local/lib/opensc-pkcs11.so` on the workstation.

**Aliases**: `cat`→bat, `vim`/`v`→nvim, `lazy`→lazygit, `tmx`→tmux, `stwo`→stow, `dps`→dockerps

**Functions** (scripts.zsh): `box A|B|F|P` look up an EC2 box by name, `nah [-f]` git reset, `snipe` kill process via fzf, `activate` source venv, `zeload` reload zshrc, `mkd` mkdir+cd, `paths` list PATH, `dockerps` formatted docker ps, `filesize` sorted file sizes, `today` current date, `keychron [-u]` hidraw permissions, `trim` strip whitespace, `rgrep` recursive grep

**Keybindings**: `Ctrl+P/N` history search, `Ctrl+Z` fg

## Development Workflow

1. Edit configs in package directory
2. Test with `stow -R <package>`
3. For Nix packages: edit packages.nix, run `home-manager switch --impure`
