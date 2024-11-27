{
  workstation =
    { ... }:
    {
      imports = [
        ../base/base16

        ./monitors.nix

        ./gtk-theme
        ./sing-box
        ./wallpaper
      ];
    };
  home-manager =
    { ... }:
    {
      imports = [
        ../base/immutable-file.nix
        ../base/base16

        ./gtk-theme
        ./wallpaper
      ];
    };
  admin = import ../base/admin;
  atuin = import ./atuin;
  cloud = import ./cloud;
  nixbuild = import ./nixbuild;
  o11y = import ./o11y;
  sing-box = import ./sing-box;
  subgen = import ./subgen;
  gemini-openai-proxy = import ./gemini-openai-proxy;
  unguarded = import ./unguarded;
  chinadns = import ./chinadns;
}
