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

      # Helper to create home configuration for a system
      mkHomeConfig = system: home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        extraSpecialArgs = { inherit username homeDir; };
        modules = [ ./home.nix ];
      };
    in {
      homeConfigurations = {
        # Default config uses current user (requires --impure)
        "${username}" = mkHomeConfig "x86_64-linux";

        # Named configs for specific systems
        "linux" = mkHomeConfig "x86_64-linux";
        "linux-arm" = mkHomeConfig "aarch64-linux";
        "macos" = mkHomeConfig "aarch64-darwin";
      };
    };
}
