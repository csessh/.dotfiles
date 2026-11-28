{ pkgs, workstationUser, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./gnome.nix
    ./yubikey.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  zramSwap.enable = true;

  networking.hostName = "fw13";
  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Ho_Chi_Minh";
  i18n.defaultLocale = "en_AU.UTF-8";
  i18n.extraLocales = [ "en_US.UTF-8/UTF-8" ];
  console.keyMap = "us";
  services.xserver.xkb.layout = "au";

  programs.localsend.enable = true;
  services.fprintd.enable = true;

  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ workstationUser ];
  };
  programs._1password.enable = true;

  services.tailscale.enable = true;
  virtualisation.docker.enable = true;

  # Mason's prebuilt LSP binaries expect a standard dynamic loader
  programs.nix-ld.enable = true;
  programs.zsh.enable = true;

  users.users.${workstationUser} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "networkmanager" ];
    shell = pkgs.zsh;
  };

  environment.systemPackages = with pkgs; [
    curl
    git
    gnumake
    stow
    unzip
  ];

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Only applies to `nixos-rebuild build-vm` (tests/vm.sh nixos)
  virtualisation.vmVariant = {
    virtualisation.diskSize = 16384;
    virtualisation.memorySize = 4096;
    virtualisation.cores = 4;
    services.openssh.enable = true;
    services.openssh.authorizedKeysFiles = [ "/tmp/shared/authorized_keys" ];
    # sshd rejects key files under world-writable /tmp otherwise
    services.openssh.settings.StrictModes = false;
    security.sudo.wheelNeedsPassword = false;
  };

  system.stateVersion = "26.05";
}
