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

      # Detect current system (requires --impure)
      currentSystem = builtins.currentSystem;

      # Helper to create home configuration for a system
      mkHomeConfig = system: desktopEnabled:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
          extraSpecialArgs = { inherit username homeDir desktopEnabled; };
          modules = [ ./home.nix ];
        };
    in {
      homeConfigurations = {
        # Default config for `home-manager switch --impure` on the current system
        "${username}" = mkHomeConfig currentSystem false;

        # Server configs (minimal CLI-only install)
        "linux-server" = mkHomeConfig "x86_64-linux" false;
        "linux-arm-server" = mkHomeConfig "aarch64-linux" false;
      };
    };
}
