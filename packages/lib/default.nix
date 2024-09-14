{ pkgs, ... }:
{
  mkNixBackground = pkgs.callPackage ./nix-background.nix { };
}
