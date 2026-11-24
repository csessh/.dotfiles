{ pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  zramSwap.enable = true;

  networking.hostName = "fw13";
  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Ho_Chi_Minh";
  i18n.defaultLocale = "en_AU.UTF-8";
  # bootstrap.sh exports LC_ALL=en_US.UTF-8
  i18n.extraLocales = [ "en_US.UTF-8/UTF-8" ];
  console.keyMap = "us";
  services.xserver.xkb.layout = "au";

  services.desktopManager.gnome.enable = true;
  services.displayManager.gdm.enable = true;
  hardware.graphics.enable = true;
  # Native Wayland for Electron apps (Obsidian, 1Password, ...)
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  i18n.inputMethod = {
    enable = true;
    type = "ibus";
    ibus.engines = with pkgs.ibus-engines; [ bamboo ];
  };

  # Fingerprint for login and sudo (pam_fprintd, sufficient: fingerprint or password)
  services.fprintd.enable = true;

  # Yubikey PIV for SSH; GNOME's gcr agent lacks PKCS#11 support
  services.pcscd.enable = true;
  programs.ssh.startAgent = true;
  programs.ssh.agentPKCS11Whitelist = "/nix/store/*";
  services.gnome.gcr-ssh-agent.enable = false;

  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "tdo" ];
  };
  programs._1password.enable = true;

  services.tailscale.enable = true;
  virtualisation.docker.enable = true;
  # Mason's prebuilt LSP binaries expect a standard dynamic loader
  programs.nix-ld.enable = true;
  programs.zsh.enable = true;

  users.users.tdo = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "networkmanager" ];
    shell = pkgs.zsh;
  };

  environment.systemPackages = with pkgs; [
    curl
    git
    gnumake
    opensc
    stow
    unzip

    dbeaver-bin
    ghostty
    google-chrome
    localsend
    obsidian
    postman
    yubioath-flutter
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

  system.stateVersion = "26.11";
}
