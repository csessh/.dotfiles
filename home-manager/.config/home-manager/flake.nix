{
  description = "Home Manager and NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { nixpkgs, nixpkgs-unstable, home-manager, nixos-hardware, ... }:
    let
      username = builtins.getEnv "USER";
      homeDir = builtins.getEnv "HOME";
      currentSystem = builtins.currentSystem;
      workstationUser = "tdo";

      overlay = import ./overlays.nix { inherit nixpkgs-unstable; };

      # Standalone home-manager for Fedora/Ubuntu servers (needs --impure for $USER/$HOME)
      mkServerHome = system:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
            overlays = [ overlay ];
          };
          extraSpecialArgs = { inherit username homeDir; };
          modules = [ ./home/common.nix ./home/server.nix ];
        };
    in
    {
      homeConfigurations = {
        "${username}" = mkServerHome currentSystem;
        "linux-server" = mkServerHome "x86_64-linux";
        "linux-arm-server" = mkServerHome "aarch64-linux";
      };

      # Workstation: NixOS with home-manager as a module (pure, no --impure needed)
      nixosConfigurations.fw13 = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit workstationUser; };
        modules = [
          ./nixos/configuration.nix
          { nixpkgs.overlays = [ overlay ]; }
          nixos-hardware.nixosModules.framework-13-7040-amd
          home-manager.nixosModules.home-manager
          ({ config, ... }: {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {
              username = workstationUser;
              homeDir = config.users.users.${workstationUser}.home;
            };
            home-manager.users.${workstationUser}.imports = [ ./home/common.nix ./home/desktop.nix ];
          })
        ];
      };

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
    };
}
