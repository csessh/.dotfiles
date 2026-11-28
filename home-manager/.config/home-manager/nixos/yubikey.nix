{ pkgs, ... }:

{
  environment.systemPackages = [ pkgs.opensc ];
  programs.ssh.agentPKCS11Whitelist = "/nix/store/*";
  programs.ssh.startAgent = true;
  services.gnome.gcr-ssh-agent.enable = false;
  services.pcscd.enable = true;
  systemd.services.pcscd.restartIfChanged = false;
}
