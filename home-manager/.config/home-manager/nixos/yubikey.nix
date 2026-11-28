{ pkgs, ... }:

{
  services.pcscd.enable = true;
  programs.ssh.startAgent = true;
  programs.ssh.agentPKCS11Whitelist = "/nix/store/*";
  services.gnome.gcr-ssh-agent.enable = false;
  environment.systemPackages = [ pkgs.opensc ];
}
