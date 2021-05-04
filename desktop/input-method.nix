{ pkgs, ... }: {
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [ fcitx5-chinese-addons fcitx5-pinyin-zhwiki ];
  };
  environment.variables = {
    GLFW_IM_MODULE = "ibus";
  };
}
