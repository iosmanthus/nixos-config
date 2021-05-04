{ system, ... }:
(self: super: {
  fcitx5-configtool = (
    import (
      fetchTarball {
        url = "https://github.com/NixOS/nixpkgs/archive/e1ff5c3d8c4ca7101f2c820f85d8290303deaa53.tar.gz";
        sha256 = "1w973fh4hnfzp9fqr4b632rspww72dvarxsrkri4la78ggn0qnyr";
      }
    ) { inherit system; }
  ).fcitx5-configtool;
})
