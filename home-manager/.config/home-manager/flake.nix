{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      # Read from environment (requires --impure flag)
      username = builtins.getEnv "USER";
      homeDir = builtins.getEnv "HOME";

      # Read host type from file (defaults to "desktop" if not found)
      hostTypeFile = "${homeDir}/.config/host-type";
      hostType =
        if builtins.pathExists hostTypeFile
        then builtins.replaceStrings ["\n"] [""] (builtins.readFile hostTypeFile)
        else "desktop";
      isDesktop = hostType == "desktop";

      # Detect current system (requires --impure)
      currentSystem = builtins.currentSystem;

      # Helper to create home configuration for a system
      mkHomeConfig = system: desktopEnabled:
        let
          isDarwin = builtins.match ".*-darwin" system != null;
        in
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
          extraSpecialArgs = { inherit username homeDir desktopEnabled isDarwin; };
          modules = [ ./home.nix ];
        };
    in {
      homeConfigurations = {
        # Default config uses current system and reads host type from file
        "${username}" = mkHomeConfig currentSystem isDesktop;

        # Desktop configs (full install with GUI apps)
        "linux" = mkHomeConfig "x86_64-linux" true;
        "linux-arm" = mkHomeConfig "aarch64-linux" true;
        "macos" = mkHomeConfig "aarch64-darwin" true;

        # Server configs (minimal CLI-only install)
        "linux-server" = mkHomeConfig "x86_64-linux" false;
        "linux-arm-server" = mkHomeConfig "aarch64-linux" false;
      };
    };
}
