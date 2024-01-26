{ pkgs, ... }:

{
  fonts = {
    packages = with pkgs; [
      apple-fonts
      cantarell-fonts
      cascadia-code
      dejavu_fonts
      fira
      fira-code
      font-awesome
      hack-font
      hasklig
      ibm-plex
      inconsolata
      inter
      iosevka
      jetbrains-mono
      jetbrains-nerd-font
      material-design-icons
      meslo-lg
      monaspace
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      noto-fonts-extra
      open-sans
      polybar-fonts
      roboto
      roboto-mono
      sf-mono
      siji
      source-han-mono
      source-han-sans
      ubuntu_font_family
      vistafonts-chs

      (nerdfonts.override {
        fonts = [ "DroidSansMono" "LiberationMono" "Iosevka" "Hasklig" "JetBrainsMono" "FiraCode" ];
      })
    ];

    fontconfig = {
      antialias = true;
      localConf = ''
        <?xml version='1.0'?>
        <!DOCTYPE fontconfig SYSTEM 'fonts.dtd'>
        <fontconfig>
          <match target="pattern">
            <test qual="any" name="family">
              <string>sans-serif</string>
            </test>
            <edit mode="prepend" binding="strong" name="family">
              <string>SF Pro Text</string>
            </edit>
          </match>
          <match target="pattern">
            <test qual="any" name="family">
              <string>serif</string>
            </test>
            <edit mode="prepend" binding="strong" name="family">
              <string>SF Pro Text</string>
            </edit>
          </match>
          <match target="pattern">
            <test qual="any" name="family">
              <string>monospace</string>
            </test>
            <edit mode="prepend" binding="strong" name="family">
              <string>Meslo LG M</string>
            </edit>
          </match>
          <match>
            <test name="family">
              <string>monospace</string>
            </test>
            <edit name="family" mode="append_last" binding="strong">
              <string>Noto Color Emoji</string>
            </edit>
          </match>
          <!-- Fallback fonts preference order -->
          <alias>
            <family>sans-serif</family>
            <prefer>
              <family>Noto Color Emoji</family>
              <family>Microsoft YaHei</family>
            </prefer>
          </alias>
          <alias>
            <family>serif</family>
            <prefer>
              <family>Noto Color Emoji</family>
              <family>Microsoft YaHei</family>
            </prefer>
          </alias>
          <alias>
            <family>monospace</family>
            <prefer>
              <family>LiterationMono Nerd Font</family>
            </prefer>
          </alias>
        </fontconfig>
      '';
    };
  };
}
