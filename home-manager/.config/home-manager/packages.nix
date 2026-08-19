{ pkgs, lib, desktopEnabled ? true, ... }:

let
  lsoff = pkgs.buildGoModule rec {
    pname = "lsoff";
    version = "0.1.3";

    src = pkgs.fetchFromGitHub {
      owner = "yutat23";
      repo = "lsoff";
      rev = "v${version}";
      hash = "sha256-ZhckDheORnoKz2468jUu1J4bAvY9yA8opUFn84alguA=";
    };

    vendorHash = "sha256-IQJQwWWL7fRbfA+u92yv7oV5LYuhu8BW4DGTlHHwXs4=";

    meta = with pkgs.lib; {
      description = "lsof-like TUI for listing listening TCP/UDP ports";
      homepage = "https://github.com/yutat23/lsoff";
      license = licenses.mit;
      mainProgram = "lsoff";
    };
  };

  basePackages = with pkgs; [
    ############################
    # CLI tools
    ############################
    bat
    btop
    fastfetch
    fd
    fzf
    glow
    lazygit
    lsoff
    pv
    ripgrep
    tldr
    tree
    zoxide

    ############################
    # Dev tools
    ############################
    delta  # git-delta
    gcc
    git
    git-lfs
    neovim
    ngrok
    tmux
    gh

    ############################
    # Languages & toolchains
    ############################
    go
    lua5_4
    nodejs
    python3
    uv
  ];

  desktopPackages = with pkgs; [
    ############################
    # AI tools
    ############################
    claude-code

    ############################
    # Desktop apps
    ############################
    _1password-gui

    ############################
    # Fonts
    ############################
    nerd-fonts.commit-mono

    ############################
    # Utilities
    ############################
    xclip

    ############################
    # Security
    # Note: opensc is installed via native package manager (dnf/apt)
    # to ensure ABI compatibility with system openssh
    ############################
    pam_u2f
    pcsclite
    yubikey-manager

  ];

in {
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

  home.packages = basePackages ++ (if desktopEnabled then desktopPackages else []);

  # Ensure fonts are available (desktop only)
  fonts.fontconfig.enable = desktopEnabled;

}
