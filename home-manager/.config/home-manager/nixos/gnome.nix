{ pkgs, ... }:

{
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  hardware.graphics.enable = true;

  i18n.inputMethod = {
    enable = true;
    type = "ibus";
    ibus.engines = with pkgs.ibus-engines; [ bamboo ];
  };

  services.desktopManager.gnome.enable = true;
  services.displayManager.gdm.enable = true;
  services.logind.settings.Login = {
    HandleLidSwitch = "ignore";
    HandleLidSwitchExternalPower = "ignore";
    HandleLidSwitchDocked = "ignore";
  };
}
