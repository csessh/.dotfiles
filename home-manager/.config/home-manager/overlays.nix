{ nixpkgs-unstable }:

final: prev:
let
  unstablePkgs = import nixpkgs-unstable {
    inherit (prev.stdenv.hostPlatform) system;
    config.allowUnfree = true;
  };
in
{
  lsoff = final.callPackage ./pkgs/lsoff.nix { };
  obel-mono = final.callPackage ./pkgs/obel-mono.nix { };

  # Drop an override once stable catches up
  codegraph = unstablePkgs.codegraph;
  claude-code = unstablePkgs.claude-code;
  # 0.8.4-rc6 panics looking for data/ next to the binary, which crashes ibus-daemon
  ibus-engines = prev.ibus-engines // {
    bamboo = unstablePkgs.ibus-engines.bamboo;
  };
}
