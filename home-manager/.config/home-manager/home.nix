{ config, pkgs, ... }:

{
  imports = [
    ./packages.nix
  ];

  home.username = "tdo";
  home.homeDirectory = "/home/tdo";

  # This value determines the home-manager release that your configuration is
  # compatible with. This helps avoid breakage when a new home-manager release
  # introduces backwards incompatible changes.
  home.stateVersion = "24.11";

  # Let home-manager install and manage itself
  programs.home-manager.enable = true;
}
