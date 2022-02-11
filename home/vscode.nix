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
        version = "1.7.4924";
        sha256 = "1zvz95a1csyy8cfyhfybkwiva9kabm4i900dxim01rn36gpas9dj";
      }
      {
        name = "github-vscode-theme";
        publisher = "GitHub";
        version = "5.2.2";
        sha256 = "1ivwjc8immvvzhmykxfs3f9da24k6hf8ln0291ysg9cj1q82533x";
      }
      {
        name = "go";
        publisher = "golang";
        version = "0.31.1";
        sha256 = "1x25x2dxcmi7h1q19qjxgnvdfzhsicq6sf6qig8jc0wg98g0gxry";
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
        version = "0.1.19";
        sha256 = "1ms96ij6z4bysdhqgdaxx2znvczyhzx57iifbqws50m1c3m7pkx7";
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
        version = "0.3.936";
        sha256 = "12ag6nn6n7bf8y004r7f254vrwx4s2wkdpq3fbh83rk4b2iklnj5";
      }
      {
        name = "vscode-docker";
        publisher = "ms-azuretools";
        version = "1.19.0";
        sha256 = "0qg4k5ivwa54i9f5ls1a0wl7blpymaq03dakdvvzallarip01qkf";
      }
      {
        name = "remote-ssh";
        publisher = "ms-vscode-remote";
        version = "0.73.2022021015";
        sha256 = "18gwf9r9fsqxrgdjh70ii3b0fw9i1yvq9g978ww69mr25yai2p7j";
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
        version = "4.13.0";
        sha256 = "0b5z08v34q10xlbjbb5sn3zdwq6bflhd96z3dqsiakywhrsxi0jm";
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
        version = "1.4.0";
        sha256 = "19a7ii4zrwcqb331jx78h7qpz8a4ar1w77k7nw43mcczx9gkb7sa";
      }
      {
        name = "tabnine-vscode";
        publisher = "TabNine";
        version = "3.5.24";
        sha256 = "09ybkshjinr9rzwbg6pcbs7qjiww8x2rz00293qb2jhvp6ljk0m0";
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
        version = "1.22.1";
        sha256 = "0hp2qw9qpp70pqblpybgpngisz98q6jk8zsabxlxy25j3hgzbhc3";
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
        "editor.inlineSuggest.enabled" = true;

        "terminal.integrated.commandsToSkipShell" = [ "-workbench.action.quickOpen" ];
        "terminal.integrated.fontFamily" = "'Dejavu Sans Mono'";
        "terminal.integrated.fontWeight" = "normal";
        "terminal.integrated.fontWeightBold" = "600";

        "window.menuBarVisibility" = "toggle";
        "window.newWindowDimensions" = "inherit";

        "workbench.colorTheme" = "GitHub Dark";
        "workbench.iconTheme" = "material-icon-theme";

        "nix.enableLanguageServer" = true;
        "tabnine.experimentalAutoImports" = true;
      };
  };
}
