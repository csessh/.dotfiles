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
      # Read from environment (requires --impure flag)
      username = builtins.getEnv "USER";
      homeDir = builtins.getEnv "HOME";

      # Detect current system (requires --impure)
      currentSystem = builtins.currentSystem;

      workstationUser = "tdo";

      # Not yet in the stable channel
      unstableOverlay = final: prev:
        let
          unstablePkgs = import nixpkgs-unstable {
            inherit (prev.stdenv.hostPlatform) system;
            config.allowUnfree = true;
          };
        in {
          codegraph = unstablePkgs.codegraph;
          claude-code = unstablePkgs.claude-code;
          # 0.8.4-rc6 panics looking for data/ next to the binary, which crashes ibus-daemon
          ibus-engines = prev.ibus-engines // {
            bamboo = unstablePkgs.ibus-engines.bamboo;
          };
        };

      # Helper to create home configuration for a system
      mkHomeConfig = system: desktopEnabled:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
            overlays = [ unstableOverlay ];
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
        specialArgs = { inherit workstationUser; };
        modules = [
          ./nixos/configuration.nix
          { nixpkgs.overlays = [ unstableOverlay ]; }
          nixos-hardware.nixosModules.framework-13-7040-amd
          home-manager.nixosModules.home-manager
          ({ config, ... }: {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {
              username = workstationUser;
              homeDir = config.users.users.${workstationUser}.home;
              desktopEnabled = true;
            };
            home-manager.users.${workstationUser} = { pkgs, ... }: {
              imports = [ ./home.nix ];
              home.file.".local/lib/opensc-pkcs11.so".source = "${pkgs.opensc}/lib/opensc-pkcs11.so";
            };
          })
        ];
      };
    };
}
