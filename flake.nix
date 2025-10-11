{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-25.05";
    flake-utils.url = "github:numtide/flake-utils";
    flake-compat.url = "https://flakehub.com/f/edolstra/flake-compat/1.tar.gz";

    gotk4-nix.url = "github:diamondburned/gotk4-nix";
    gotk4-nix.inputs = {
      nixpkgs.follows = "nixpkgs";
      flake-utils.follows = "flake-utils";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      gotk4-nix,
      flake-utils,
      flake-compat,
    }:

    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            gotk4-nix.overlays.patchelf
          ];
        };
      in
      {
        devShells.default = gotk4-nix.lib.mkShell {
          base = {
            pname = "gotk4-webkitgtk";
            buildInputs = pkgs: with pkgs; [
              webkitgtk_4_1
              webkitgtk_6_0
              libsoup_2_4
              libsoup_3
            ];
          };
          inherit pkgs;
          inherit (pkgs) go gopls gotools;
        };
      }
    );
}
