{ pkgs
, ...
}:
{
  home.packages = with pkgs;[ nixpkgs-fmt rnix-lsp ];
  programs.vscode = {
    enable = true;
    extensions = pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "better-comments";
        publisher = "aaron-bond";
        version = "2.1.0";
        sha256 = "0kmmk6bpsdrvbb7dqf0d3annpg41n9g6ljzc1dh0akjzpbchdcwp";
      }
      {
        name = "gitlens";
        publisher = "eamodio";
        version = "11.7.0";
        sha256 = "0apjjlfdwljqih394ggz2d8m599pyyjrb0b4cfcz83601b7hk3x6";
      }
      {
        name = "vsc-community-material-theme";
        publisher = "Equinusocio";
        version = "1.4.4";
        sha256 = "005l4pr9x3v6x8450jn0dh7klv0pv7gv7si955r7b4kh19r4hz9y";
      }
      {
        name = "shell-format";
        publisher = "foxundermoon";
        version = "7.2.2";
        sha256 = "00wc0y2wpdjs2pbxm6wj9ghhfsvxyzhw1vjvrnn1jfyl4wh3krvi";
      }
      {
        name = "copilot";
        publisher = "GitHub";
        version = "1.7.4421";
        sha256 = "1wvzf8rq8ligj079f1m74zzna2mfmhcbgvvrsw6w0wxw9x8fn4wy";
      }
      {
        name = "go";
        publisher = "golang";
        version = "0.30.0";
        sha256 = "15rmc79ad743hb6pmnzv91rkvl2fb1qwh5gk5q6n9f9vygiyjrix";
      }
      {
        name = "haskell";
        publisher = "haskell";
        version = "1.8.0";
        sha256 = "0yzcibigxlvh6ilba1jpri2irsjnvyy74vzn3rydcywfc17ifkzs";
      }
      {
        name = "nix-ide";
        publisher = "jnoortheen";
        version = "0.1.18";
        sha256 = "1v3j67j8bydyqba20b2wzsfximjnbhknk260zkc0fid1xzzb2sbn";
      }
      {
        name = "language-haskell";
        publisher = "justusadam";
        version = "3.4.0";
        sha256 = "0ab7m5jzxakjxaiwmg0jcck53vnn183589bbxh3iiylkpicrv67y";
      }
      {
        name = "rust-analyzer";
        publisher = "matklad";
        version = "0.2.853";
        sha256 = "0fasdv9wazir6qv2qvmn0wsy2v5lwa4lhxq7scqwr16wxhzbr2hx";
      }
      {
        name = "vscode-docker";
        publisher = "ms-azuretools";
        version = "1.18.0";
        sha256 = "0hhlhx3xy7x31xx2v3srvk67immajs6dm9h0wi49ii1rwx61zxah";
      }
      {
        name = "remote-ssh-edit";
        publisher = "ms-vscode-remote";
        version = "0.71.2021121615";
        sha256 = "0ymrfsvls2y9dzhxx71kb3jqm7vznj1z39nb89pykyk76jsn70gv";
      }
      {
        name = "remote-ssh-nightly";
        publisher = "ms-vscode-remote";
        version = "2021.12.12420";
        sha256 = "1z0mizgb92w3hxj3m8mffdmkd5724mzn34szbnf27hiixmyzp32j";
      }
      {
        name = "color-highlight";
        publisher = "naumovs";
        version = "2.5.0";
        sha256 = "0ri1rylg0r9r1kdc67815gjlq5fwnb26xpyziva6a40brrbh70vm";
      }
      {
        name = "material-icon-theme";
        publisher = "PKief";
        version = "4.11.0";
        sha256 = "1l2s8j645riqjmj09i3v71s8ycin5vd6brdp35z472fnk6wyi1y6";
      }
      {
        name = "vscode-commons";
        publisher = "redhat";
        version = "0.0.6";
        sha256 = "1b8nlhbrsg3kj27f1kgj8n5ak438lcfq5v5zlgf1hzisnhmcda5n";
      }
      {
        name = "vscode-yaml";
        publisher = "redhat";
        version = "1.2.2";
        sha256 = "06n4fxqr3lqmiyns9jdk3rdnanamcpzhrivllai8z9d997xmwcx6";
      }
      {
        name = "tabnine-vscode";
        publisher = "TabNine";
        version = "3.5.11";
        sha256 = "1is8dsjs5kqn960wnr548ivy9r94nvzhgn7nky28wi9w42xi64im";
      }
      {
        name = "even-better-toml";
        publisher = "tamasfe";
        version = "0.14.2";
        sha256 = "17djwa2bnjfga21nvyz8wwmgnjllr4a7nvrsqvzm02hzlpwaskcl";
      }
      {
        name = "vim";
        publisher = "vscodevim";
        version = "1.21.10";
        sha256 = "0c9m7mc2kmfzj3hkwq3d4hj43qha8a75q5r1rdf1xfx8wi5hhb1n";
      }
      {
        name = "markdown-all-in-one";
        publisher = "yzhang";
        version = "3.4.0";
        sha256 = "0ihfrsg2sc8d441a2lkc453zbw1jcpadmmkbkaf42x9b9cipd5qb";
      }
      {
        name = "vscode-proto3";
        publisher = "zxh404";
        version = "0.5.5";
        sha256 = "08gjq2ww7pjr3ck9pyp5kdr0q6hxxjy3gg87aklplbc9bkfb0vqj";
      }
    ];

    keybindings = [
      {
        command = "selectNextSuggestion";
        key = "tab";
        when = "editorTextFocus && suggestWidgetMultipleSuggestions && suggestWidgetVisible";
      }
      {
        command = "selectPrevSuggestion";
        key = "shift+tab";
        when = "editorTextFocus && suggestWidgetMultipleSuggestions && suggestWidgetVisible";
      }
      {
        command = "-rust-analyzer.onEnter";
        key = "enter";
        when = "editorTextFocus && !suggestWidgetVisible && editorLangId == 'rust'";
      }
    ];
    userSettings =
      let
        fcitx5-remote = "${pkgs.fcitx5}/bin/fcitx5-remote";
      in
      {
        "extensions.autoUpdate" = false;
        "security.workspace.trust.enabled" = false;

        "keyboard.dispatch" = "keyCode";
        "vim.autoSwitchInputMethod.defaultIM" = "1";
        "vim.autoSwitchInputMethod.enable" = true;
        "vim.autoSwitchInputMethod.obtainIMCmd" = "${fcitx5-remote}";
        "vim.autoSwitchInputMethod.switchIMCmd" = "${fcitx5-remote} -t {im}";
        "vim.camelCaseMotion.enable" = true;
        "vim.debug.silent" = true;
        "vim.easymotion" = true;
        "vim.enableNeovim" = true;
        "vim.easymotionMarkerFontFamily" = "monospace";
        "vim.handleKeys" = {
          "<C-a>" = false;
          "<C-c>" = false;
          "<C-d>" = false;
          "<C-f>" = false;
          "<C-j>" = false;
          "<C-k>" = false;
        };
        "vim.highlightedyank.enable" = true;
        "vim.hlsearch" = true;
        "vim.leader" = "<space>";
        "vim.normalModeKeyBindingsNonRecursive" = [
          {
            before = [ "<C-n>" ];
            commands = [ ":nohl" ];
          }
          {
            before = [ ";" ];
            commands = [ "vim.showQuickpickCmdLine" ];
          }
        ];
        "vim.visualstar" = true;

        "editor.fontFamily" = "'Dejavu Sans Mono', 'Material-Design-Iconic-Font', feather";
        "editor.fontLigatures" = true;
        "editor.fontSize" = 13;
        # "editor.fontWeight": "650",
        "editor.lineHeight" = 25;
        "editor.lineNumbers" = "relative";

        "terminal.integrated.commandsToSkipShell" = [ "-workbench.action.quickOpen" ];
        "terminal.integrated.fontFamily" = "'Dejavu Sans Mono'";
        "terminal.integrated.fontWeight" = "normal";
        "terminal.integrated.fontWeightBold" = "600";

        "window.menuBarVisibility" = "toggle";
        "window.newWindowDimensions" = "inherit";

        "workbench.colorTheme" = "Community Material Theme Darker High Contrast";
        "workbench.iconTheme" = "material-icon-theme";

        "nix.enableLanguageServer" = true;
        "tabnine.experimentalAutoImports" = true;
      };
  };
}
