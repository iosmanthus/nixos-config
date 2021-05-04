{ system, ... }:
builtins.map (
  module:
    import module {
      inherit system;
    }
)
  [
    ./firmware.nix
    ./tun2socks.nix
    ./clash-premium.nix
    ./feeluown.nix
    ./fcitx5.nix
    ./kitty.nix
  ]
