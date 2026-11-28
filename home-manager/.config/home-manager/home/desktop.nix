{ pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    ############################
    # AI tools
    ############################
    claude-code
    rtk

    ############################
    # Cloud
    ############################
    awscli2
    ssm-session-manager-plugin

    ############################
    # Fonts
    ############################
    obel-mono

    ############################
    # Apps
    ############################
    dbeaver-bin
    discord
    ghostty
    google-chrome
    postman

    ############################
    # Utilities
    ############################
    cargo
    cloud-utils
    qemu
    wl-clipboard

    ############################
    # Security
    ############################
    yubikey-manager
    yubioath-flutter
  ];

  fonts.fontconfig.enable = true;

  # .zshrc's `ssh-add -s` loads the Yubikey PIV key through this path
  home.file.".local/lib/opensc-pkcs11.so".source = "${pkgs.opensc}/lib/opensc-pkcs11.so";

  dconf.settings = {
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

    "org/gnome/desktop/session".idle-delay = lib.hm.gvariant.mkUint32 600;
    "org/gnome/settings-daemon/plugins/power" = {
      sleep-inactive-ac-type = "nothing";
      sleep-inactive-battery-type = "suspend";
      sleep-inactive-battery-timeout = 900;
    };
  };
}
