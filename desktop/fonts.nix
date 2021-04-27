{ pkgs, ... }:

{
  fonts = {
    fonts = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-extra
      noto-fonts-emoji
      source-han-sans
      fira-code
      cascadia-code
      liberation_ttf
      hasklig
      roboto
      (nerdfonts.override { fonts = [ "DroidSansMono" ]; })
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
            <string>Roboto</string>
           </edit>
          </match>
          <match target="pattern">
           <test qual="any" name="family">
            <string>serif</string>
           </test>
           <edit mode="prepend" binding="strong" name="family">
            <string>Roboto</string>
           </edit>
          </match>
          <match target="pattern">
           <test qual="any" name="family">
            <string>monospace</string>
           </test>
           <edit mode="prepend" binding="strong" name="family">
            <string>Liberation Mono</string>
           </edit>
          </match>
          <!-- Fallback fonts preference order -->
          <alias>
           <family>sans-serif</family>
           <prefer>
            <family>Noto Color Emoji</family>
            <family>Source Han Sans SC</family>
           </prefer>
          </alias>
          <alias>
           <family>serif</family>
           <prefer>
            <family>Noto Color Emoji</family>
            <family>Source Han Sans SC</family>
           </prefer>
          </alias>
          <alias>
           <family>monospace</family>
           <prefer>
            <family>Fira Code</family>
           </prefer>
          </alias>
        </fontconfig>
      '';
    };
  };
}
