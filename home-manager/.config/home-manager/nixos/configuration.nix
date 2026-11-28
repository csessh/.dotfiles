{ pkgs, workstationUser, ... }:

{
  imports = [
    ./gnome.nix
    ./hardware-configuration.nix
    ./system-integrated-application.nix
    ./yubikey.nix
  ];

  ############################
  # Boot & hardware
  ############################
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.systemd-boot.enable = true;
  services.fprintd.enable = true;
  zramSwap.enable = true;

  ############################
  # Networking
  ############################
  networking.hostName = "fw13";
  networking.networkmanager.enable = true;
  services.tailscale.enable = true;

  ############################
  # Locale
  ############################
  console.keyMap = "us";
  i18n.defaultLocale = "en_AU.UTF-8";
  i18n.extraLocales = [ "en_US.UTF-8/UTF-8" ];
  services.xserver.xkb.layout = "au";
  time.timeZone = "Asia/Ho_Chi_Minh";

  ############################
  # User & shell
  ############################
  programs.zsh.enable = true;
  users.users.${workstationUser} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "networkmanager" ];
    shell = pkgs.zsh;
  };

  ############################
  # Development
  # Mason's prebuilt LSP binaries expect a standard dynamic loader
  ############################
  programs.nix-ld.enable = true;
  virtualisation.docker.enable = true;

  ############################
  # Nix & system packages
  ############################
  nixpkgs.config.allowUnfree = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
  nix.settings.auto-optimise-store = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Root and bootstrap need these; user tools live in home/
  environment.systemPackages = with pkgs; [
    curl
    git
    gnumake
    stow
    unzip
  ];

  ############################
  # VM test (`nixos-rebuild build-vm`, tests/vm.sh nixos only)
  ############################
  virtualisation.vmVariant = {
    security.sudo.wheelNeedsPassword = false;
    services.openssh.authorizedKeysFiles = [ "/tmp/shared/authorized_keys" ];
    services.openssh.enable = true;
    virtualisation.cores = 4;
    virtualisation.diskSize = 16384;
    virtualisation.memorySize = 4096;

    # sshd rejects key files under world-writable /tmp otherwise
    services.openssh.settings.StrictModes = false;
  };

  system.stateVersion = "26.05";
}
