{
  description = "Nix Overlays";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    let
      overlays = import ./overlays.nix;
      overlays' = builtins.attrValues overlays;
    in
    (
      flake-utils.lib.eachDefaultSystem
        (
          system:
          let
            pkgs = import nixpkgs {
              inherit system;
              overlays = overlays';
            };
          in
          rec {
            packages = {
              inherit (pkgs) pynng sparselm eigen;
            };
            devShell = pkgs.mkShell {
              nativeBuildInputs = [ pkgs.pkg-config ];
              buildInputs = builtins.attrValues packages;
            };
          }
        ) // {
        inherit overlays;
      }
    );
}
