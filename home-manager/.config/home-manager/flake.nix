{
  description = "Home Manager and NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware";
  };

  outputs = { nixpkgs, home-manager, nixos-hardware, ... }:
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

      # Workstation: NixOS with home-manager as a module (pure, no --impure needed)
      nixosConfigurations.fw13 = nixpkgs.lib.nixosSystem {
        modules = [
          ./nixos/configuration.nix
          nixos-hardware.nixosModules.framework-13-7040-amd
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {
              username = "tdo";
              homeDir = "/home/tdo";
              desktopEnabled = true;
            };
            home-manager.users.tdo = { pkgs, ... }: {
              imports = [ ./home.nix ];
              home.file.".local/lib/opensc-pkcs11.so".source = "${pkgs.opensc}/lib/opensc-pkcs11.so";
            };
          }
        ];
      };
    };
}
