{ pkgs, ... }: {
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [ fcitx5-chinese-addons ];
  };
  environment.systemPackages = with pkgs;[
    fcitx5-gtk
    fcitx5-pinyin-zhwiki
  ];
}
