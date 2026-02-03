# Ghostty macOS Homebrew Installation Design

**Date:** 2026-02-03
**Status:** Approved

## Problem

Ghostty is not available or working via Nix on Darwin (macOS). Need to install via Homebrew instead while maintaining Nix installation for Linux.

## Solution

Use platform detection to:
1. Exclude Ghostty from Nix packages on Darwin
2. Install Ghostty via Homebrew in bootstrap.sh for macOS

## Changes

### 1. flake.nix

Add `isDarwin` derivation inside `mkHomeConfig` and pass to modules:

```nix
mkHomeConfig = system: desktopEnabled:
  let
    isDarwin = builtins.match ".*-darwin" system != null;
  in
  home-manager.lib.homeManagerConfiguration {
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
    extraSpecialArgs = {
      inherit username homeDir desktopEnabled isDarwin;
    };
    modules = [ ./home.nix ];
  };
```

### 2. packages.nix

Add `isDarwin` parameter and filter Ghostty:

```nix
{ pkgs, lib, desktopEnabled ? true, isDarwin ? false, ... }:

let
  # ... basePackages unchanged ...

  desktopPackages = with pkgs; [
    claude-code
    _1password-gui
    firefox
    nerd-fonts.commit-mono
    xclip
    pam_u2f
    yubikey-manager
  ] ++ lib.optionals (!isDarwin) [
    ghostty  # macOS: install via Homebrew instead
  ];
in { ... }
```

### 3. bootstrap.sh

Add Ghostty to macOS `install_system_packages()`:

```bash
macos)
    if ! command -v brew &> /dev/null; then
        info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    brew install --cask docker
    brew install --cask ghostty
    ;;
```

### 4. CLAUDE.md

Add platform note:

```markdown
**Platform-specific notes:**
- **Ghostty**: Linux installs via Nix; macOS installs via Homebrew (`brew install --cask ghostty`)
```

## Behavior After Implementation

| Platform | Ghostty Installation |
|----------|---------------------|
| Linux    | Nix (via desktopPackages) |
| macOS    | Homebrew (via bootstrap.sh) |

Ghostty config files remain stow-managed on both platforms.
