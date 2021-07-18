{ pkgs ? import <nixpkgs> {} }:
pkgs.mkShell {
  buildInputs = [ (pkgs.haskellPackages.ghcWithPackages (p: (with p;[ xmonad xmonad-contrib ]))) pkgs.haskell-language-server ];
}
