let
  fromPkg = name: src: final: prev:
    let
      callPackage = final.lib.callPackageWith (final // final.python3Packages);
    in
    { "${name}" = callPackage src { }; };
in
{
  pynng = fromPkg "pynng" ./packages/pynng.nix;
  eigen = fromPkg "eigen" ./packages/eigen.nix;
  sparselm = fromPkg "sparselm" ./packages/sparselm;
}
