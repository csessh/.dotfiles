{ pkgs, username, homeDir, ... }:

{
  home.username = username;
  home.homeDirectory = homeDir;

  # This value determines the home-manager release that your configuration is
  # compatible with. This helps avoid breakage when a new home-manager release
  # introduces backwards incompatible changes.
  home.stateVersion = "24.11";

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
    cmatrix
    bat
    btop
    fastfetch
    fd
    fzf
    glow
    lazygit
    lsoff
    openssl
    ripgrep
    tree
    websocat
    wget
    zoxide

    ############################
    # Dev tools
    ############################
    codegraph
    delta # git-delta
    gcc
    gh
    git
    git-lfs
    neovim
    tmux
    tree-sitter

    ############################
    # Languages & toolchains
    ############################
    go
    lua5_4
    nodejs
    (python3.withPackages (ps: [ ps.pynvim ])) # pynvim must live in the python3 nvim finds
    uv
  ];

  programs.home-manager.enable = true;
}
