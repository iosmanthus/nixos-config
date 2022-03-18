{ pkgs, ... }:

{
  fonts = {
    fonts = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-extra
      noto-fonts-emoji
      source-han-sans
      source-han-mono
      fira-code
      cascadia-code
      material-design-icons
      jetbrains-mono
      font-awesome
      hasklig
      roboto
      vistafonts-chs
      ubuntu_font_family
      polybar-fonts
      siji
      (nerdfonts.override {
        fonts = [ "DroidSansMono" "LiberationMono" "Iosevka" "Hasklig" ];
      })
    ];

    fontconfig = {
      localConf = ''
        <?xml version='1.0'?>
        <!DOCTYPE fontconfig SYSTEM 'fonts.dtd'>
        <fontconfig>
          <match target="pattern">
           <test qual="any" name="family">
            <string>sans-serif</string>
           </test>
           <edit mode="prepend" binding="strong" name="family">
            <string>Ubuntu</string>
           </edit>
          </match>
          <match target="pattern">
           <test qual="any" name="family">
            <string>serif</string>
           </test>
           <edit mode="prepend" binding="strong" name="family">
            <string>Ubuntu</string>
           </edit>
          </match>
          <match target="pattern">
           <test qual="any" name="family">
            <string>monospace</string>
           </test>
           <edit mode="prepend" binding="strong" name="family">
            <string>Hasklig</string>
           </edit>
          </match>
          <match>
            <test name="family"><string>monospace</string></test>
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
