_self: super: {
  feeluown = super.feeluown.overrideAttrs (
    _: {
      buildInputs = with super;[
        feeluown-core
        feeluown-netease
        feeluown-local
      ];
    }
  );
}
