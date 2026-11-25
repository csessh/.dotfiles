{ config, pkgs, lib, username, homeDir, desktopEnabled ? true, ... }:

{
  imports = [
    ./packages.nix
  ];

  home.username = username;
  home.homeDirectory = homeDir;

  # This value determines the home-manager release that your configuration is
  # compatible with. This helps avoid breakage when a new home-manager release
  # introduces backwards incompatible changes.
  home.stateVersion = "24.11";

  # nvim skips its LSP plugins on servers (see nvim/.config/nvim/init.lua)
  home.sessionVariables = lib.mkIf (!desktopEnabled) { NVIM_PROFILE = "server"; };

  dconf.settings = lib.mkIf desktopEnabled {
    "org/gnome/desktop/interface" = {
      font-name = "Obel Mono 11";
      document-font-name = "Obel Mono 11";
      monospace-font-name = "Obel Mono 11";
    };
    "org/gnome/desktop/wm/preferences".titlebar-font = "Obel Mono Bold 11";
  };

  # Let home-manager install and manage itself
  programs.home-manager.enable = true;
}
