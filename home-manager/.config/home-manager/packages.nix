{ pkgs, ... }:

{
  home.packages = with pkgs; [
    ############################
    # CLI tools
    ############################
    bat
    btop
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
