{ system, ... }:
(self: super: {
  feeluown = super.feeluown.overrideAttrs (
    old: {
      buildInputs = with super;[
        feeluown-core
        feeluown-netease
        feeluown-local
      ];
    }
  );
})
