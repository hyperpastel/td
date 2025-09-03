{
  description = "";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    c3c = {
        url = "github:c3lang/c3c";
        inputs.nixpkgs.follows = "nixpkgs";
        inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs =
    inputs:
    inputs.flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = inputs.nixpkgs.legacyPackages.${system};
      in
      with pkgs;
      {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            inputs.c3c.packages.${system}.default
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
