let
  pkgs = import <nixpkgs>{};

  stdenv = pkgs.stdenv;
  mkDerivation = pkgs.stdenv.mkDerivation;
  base = pkgs.haskellPackages.base;
  ghc = pkgs.ghc;

in
mkDerivation {
  pname = "ticTacToe";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [ base ];
  license = "unknown";
  inherit ghc;
  installPhase = ''
    $ghc/bin/ghc ./Main.hs
    mv ./Main $out
  '';
}
