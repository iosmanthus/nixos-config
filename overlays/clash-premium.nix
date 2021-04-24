self: super: {
  clash-premium = super.callPackage (import ../packages/clash-premium.nix) {};
}
