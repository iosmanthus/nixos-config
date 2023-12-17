{
  system = { ... }: {
    imports = [
      ./gtk-theme
      ./wallpaper
      ./sing-box

      ./monitors.nix
    ];
  };

  home-manager = { ... }: {
    imports = [
      ./gtk-theme
      ./wallpaper

      ./immutable-file.nix
      ./mutable-vscode-ext.nix
    ];
  };

  admin = import ./admin;

  lightsail = { ... }: {
    imports = [
      ./sing-box
      ./caddy
      ./subgen
      #./promtail
    ];
  };
}
