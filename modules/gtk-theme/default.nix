{ pkgs
, ...
}:
{
  imports = [
    ./theme.nix
  ];

  gtk.globalTheme = {
    package = pkgs.orchis-theme;
    name = "Orchis-Dark";
  };
}
