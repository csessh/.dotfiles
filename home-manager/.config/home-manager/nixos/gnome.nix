{ pkgs, ... }:

{
  services.desktopManager.gnome.enable = true;
  services.displayManager.gdm.enable = true;
  hardware.graphics.enable = true;
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  i18n.inputMethod = {
    enable = true;
    type = "ibus";
    ibus.engines = with pkgs.ibus-engines; [ bamboo ];
  };

  services.logind.settings.Login = {
    HandleLidSwitch = "ignore";
    HandleLidSwitchExternalPower = "ignore";
    HandleLidSwitchDocked = "ignore";
  };
}
