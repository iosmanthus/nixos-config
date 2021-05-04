{ system, ... }:
(
  self: super:
    {
      tun2socks = super.callPackage (import ../packages/tun2socks.nix) {};
    }
)
