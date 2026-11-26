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

  # nvim skips its LSP plugins on servers (see nvim/.config/nvim/init.lua). A file, not a session
  # variable: nvim started outside zsh (`ssh host nvim`, git from bash) never sources hm-session-vars.
  xdg.configFile."nvim-profile" = lib.mkIf (!desktopEnabled) { text = "server\n"; };

  # The old bootstrap wrote host-type=desktop on desktops; this server-only profile would strip their
  # GUI tooling. Runs at switch time on the target, before anything is written.
  home.activation.refuseDesktopHost = lib.mkIf (!desktopEnabled) (lib.hm.dag.entryBefore [ "writeBoundary" ] ''
    if grep -qx desktop "$HOME/.config/host-type" 2>/dev/null; then
      echo "~/.config/host-type says desktop, but this flake's standalone configs are server-only now" >&2
      echo "(desktops run NixOS: nixosConfigurations.fw13). Delete ~/.config/host-type to apply it anyway;" >&2
      echo "on the old Fedora desktop also run 'stow -D ssh' (its ssh-agent.service is gone)." >&2
      exit 1
    fi
  '');

  dconf.settings = lib.mkIf desktopEnabled {
    "org/gnome/desktop/interface" = {
      font-name = "Obel Mono 11";
      document-font-name = "Obel Mono 11";
      monospace-font-name = "Obel Mono 11";
    };
    "org/gnome/desktop/wm/preferences".titlebar-font = "Obel Mono Bold 11";

    "org/gnome/desktop/input-sources" = {
      sources = [
        (lib.hm.gvariant.mkTuple [ "xkb" "au" ])
        (lib.hm.gvariant.mkTuple [ "ibus" "Bamboo" ])
      ];
      xkb-options = [ "ctrl:nocaps" ];
    };
    "org/gnome/desktop/wm/keybindings" = {
      switch-input-source = [ "<Control>grave" ];
      switch-input-source-backward = [ "<Shift><Control>grave" ];
    };
  };

  programs.home-manager.enable = true;
}
