let
  sources = import ./nix/sources.nix;
in
{ compiler ? "ghc883"
, pkgs ? import sources.nixpkgs { }
}:

let
  inherit (pkgs.lib.trivial) flip pipe;
  inherit (pkgs.haskell.lib) appendPatch appendConfigureFlags;

  haskellPackages = pkgs.haskell.packages.${compiler}.override {
    overrides = hpNew: hpOld: {
      hakyll =
        pipe
           hpOld.hakyll
           [ (flip appendPatch ./hakyll.patch)
             (flip appendConfigureFlags [ "-f" "watchServer" "-f" "previewServer" ])
           ];

      dbueno-github-io = hpNew.callCabal2nix "dbueno-github-io" ./. { };

      niv = import sources.niv { };
    };
  };

  project = haskellPackages.dbueno-github-io;
in
{
  project = project;

  shell = haskellPackages.shellFor {
    packages = p: with p; [
      project
    ];
    buildInputs = with haskellPackages; [
      ghcid
      hlint       # or ormolu
      niv
      pkgs.cacert # needed for niv
      pkgs.nix    # needed for niv
    ];
    withHoogle = true;
  };
}
