{ pkgs
, ...
}:
{
  imports = [
    ./wallpaper.nix
  ];

  wallpaper = {
    package = pkgs.mkNixBackground {
      name = "nix-wallpaper-nineish-dark-gray";
      description = "Nineish dark gray wallpaper for NixOS";
      src = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/0ae21f8da36d7e3a89594fd42849abd7bd6bacbe/wallpapers/nix-wallpaper-nineish-dark-gray.png";
        sha256 = "07zl1dlxqh9dav9pibnhr2x1llywwnyphmzcdqaby7dz5js184ly";
      };
    };
  };
}
