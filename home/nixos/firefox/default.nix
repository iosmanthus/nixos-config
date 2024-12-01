{
  self,
  pkgs,
  config,
  ...
}:
{
  imports = [
    ../../base/firefox
  ];

  programs.firefox = {
    package = self.inputs.firefox.packages.${pkgs.system}.firefox-nightly-bin.unwrapped;
    profiles.${config.admin.name} = {
      settings = {
        "widget.content.gtk-theme-override" = config.gtk.globalTheme.name;
      };
    };
  };
}
