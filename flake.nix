{
  description = "";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:

    flake-utils.lib.eachDefaultSystem (
      system:
      # Required until https://github.com/NixOS/nixpkgs/pull/435544/ gets merged
      let
        c3c-overlay = (
          final: prev: {
            c3c = prev.c3c.overrideAttrs (old: {
              version = "0.7.5";
              doCheck = false;
              src = prev.fetchFromGitHub {
                owner = "c3lang";
                repo = "c3c";
                rev = "c0387221af7e9668b5fdde335b06e5bc89bc79fb";
                hash = "sha256-ukDjNqWqMboqOrm+dLTQZ03D7SP2DcQF22/n/CEZSMs=";
              };
            });
          }
        );
        pkgs = (nixpkgs.legacyPackages.${system}.extend c3c-overlay);
      in
      with pkgs;
      {
        devShells.default = mkShell {
          buildInputs = [
            c3c
            c3-lsp
          ];

          shellHook = ''
            export PROJECT_PREFIX=td
            echo Entered Project td
          '';
        };

      }
    );
}
