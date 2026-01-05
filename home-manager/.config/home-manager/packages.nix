{ pkgs, lib, ... }:

{
  assertions = [
    {
      assertion = builtins.compareVersions pkgs.fzf.version "0.67" >= 0;
      message = "fzf must be 0.67+, got ${pkgs.fzf.version}";
    }
    {
      assertion = builtins.compareVersions pkgs.neovim.version "0.11" >= 0;
      message = "neovim must be 0.11+, got ${pkgs.neovim.version}";
    }
    {
      assertion = builtins.compareVersions pkgs.lua5_4.version "5.4" >= 0;
      message = "lua must be 5.4+, got ${pkgs.lua5_4.version}";
    }
  ];

  home.packages = with pkgs; [
    ############################
    # CLI tools
    ############################
    bat
    btop
    cloudflared
    fastfetch
    fd
    fzf
    lazygit
    ripgrep
    tree
    unzip
    xclip
    zoxide

    ############################
    # Dev tools
    ############################
    delta  # git-delta
    gcc
    git
    git-lfs
    neovim
    stow
    tmux

    ############################
    # Languages & toolchains
    ############################
    go
    lua5_4
    nodejs
    python3
    uv

    ############################
    # Fonts
    ############################
    nerd-fonts.commit-mono

    ############################
    # Terminal
    ############################
    ghostty

    ############################
    # Security
    ############################
    yubikey-manager
  ];

  # Ensure fonts are available
  fonts.fontconfig.enable = true;
}
