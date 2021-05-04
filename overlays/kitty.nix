{ system, ... }:
(
  self: super: {
    kitty = (
      import (
        fetchTarball {
          url = "https://github.com/NixOS/nixpkgs/archive/47f4780fc3a73372971af7c09049c46769738a57.tar.gz";
          sha256 = "129gafaxd2qy9z71v4gdzjjk0n5xavay21cf6k8yd4z3p8xp4v9f";
        }
      ) {
        inherit system;
      }
    ).kitty
    ;
  }
)
