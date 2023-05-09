{ pkgs
, ...
}:
{
  imports = [
    ./theme.nix
  ];

  gtk.globalTheme = {
    package = pkgs.fluent-gtk-theme;
    name = "Fluent-Dark";
  };
}
