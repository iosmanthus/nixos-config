{
  workstation = { ... }: {
    imports = [
      ./monitors.nix

      ./base16
      ./gtk-theme
      ./sing-box
      ./wallpaper
    ];
  };
  home-manager = { ... }: {
    imports = [
      ./immutable-file.nix
      ./mutable-vscode-ext.nix

      ./base16
      ./gtk-theme
      ./wallpaper
    ];
  };
  admin = import ./admin;
  atuin = import ./atuin;
  cloud = import ./cloud;
  nixbuild = import ./nixbuild;
  o11y = import ./o11y;
  sing-box = import ./sing-box;
  subgen = import ./subgen;
  gemini-openai-proxy = import ./gemini-openai-proxy;
}
