{ pkgs
, ...
}:
let
  fcitx = "${pkgs.fcitx5}/bin/fcitx5-remote";
in
{
  home.packages = with pkgs; [
    nixpkgs-fmt
    rnix-lsp
  ];

  home.sessionVariables = {
    EDITOR = "${pkgs.runVscode} --wait";
  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    mutableExtensions = [
      {
        publisher = "equinusocio";
        name = "vsc-community-material-theme";
        version = "1.4.4";
      }
    ];
    extensions = pkgs.vscode-utils.extensionsFromVscodeMarketplace
      (builtins.fromJSON (
        builtins.readFile ./extensions.json
      )).extensions
    ++ (with pkgs.vscode-extensions; [
      matklad.rust-analyzer
      redhat.vscode-yaml
    ]);

    keybindings = [
      {
        command = "selectNextSuggestion";
        key = "tab";
        when =
          "editorTextFocus && suggestWidgetMultipleSuggestions && suggestWidgetVisible";
      }
      {
        command = "selectPrevSuggestion";
        key = "shift+tab";
        when =
          "editorTextFocus && suggestWidgetMultipleSuggestions && suggestWidgetVisible";
      }
      {
        command = "-rust-analyzer.onEnter";
        key = "enter";
        when =
          "editorTextFocus && !suggestWidgetVisible && editorLangId == 'rust'";
      }
      {
        key = "ctrl+]";
        command = "workbench.action.terminal.focusNext";
        when = "terminalFocus";
      }
      {
        key = "ctrl+[";
        command = "workbench.action.terminal.focusPrevious";
        when = "terminalFocus";
      }
    ];
    userSettings = {
      "extensions.autoUpdate" = false;
      "security.workspace.trust.enabled" = false;
      "rust-analyzer.serverPath" = "${pkgs.rust-analyzer}/bin/rust-analyzer";
      "rust-analyzer.cargo.buildScripts.enable" = true;
      "python.formatting.yapfPath" = "${pkgs.yapf}/bin/yapf";
      "python.formatting.provider" = "yapf";

      "keyboard.dispatch" = "keyCode";
      "vim.autoSwitchInputMethod.defaultIM" = "1";
      "vim.autoSwitchInputMethod.enable" = true;
      "vim.autoSwitchInputMethod.obtainIMCmd" = "${fcitx}";
      "vim.autoSwitchInputMethod.switchIMCmd" = "${fcitx} -t {im}";
      "vim.camelCaseMotion.enable" = true;
      "vim.debug.silent" = true;
      "vim.easymotion" = true;
      "vim.enableNeovim" = true;
      "vim.neovimPath" = "${pkgs.neovim}/bin/nvim";
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
        {
          before = [ "u" ];
          commands = [ "undo" ];
        }
        {
          before = [ "C-r" ];
          commands = [ "redo" ];
        }
      ];
      "vim.visualstar" = true;

      "editor.fontFamily" = "'Hack', 'SF Mono', 'Material-Design-Iconic-Font', feather";
      "editor.fontLigatures" = false;
      "editor.fontSize" = 14;
      "editor.inlineSuggest.enabled" = true;
      "editor.lineHeight" = 22;
      "editor.lineNumbers" = "relative";

      "terminal.integrated.commandsToSkipShell" = [ "-workbench.action.quickOpen" ];
      "terminal.integrated.fontFamily" = "'Hack', 'SF Mono', 'Hasklug Nerd Font'";
      "terminal.integrated.fontWeight" = "normal";
      "terminal.integrated.fontSize" = 14;
      "terminal.integrated.fontWeightBold" = 600;
      "terminal.integrated.shellIntegration.enabled" = true;

      "window.menuBarVisibility" = "toggle";
      "window.newWindowDimensions" = "inherit";

      "workbench.colorTheme" = "Default Dark+ Experimental";
      "workbench.iconTheme" = "eq-material-theme-icons-light";

      "nix.enableLanguageServer" = true;
      "nix.serverSettings.nil.formatting.command" = [ "nixpkgs-fmt" ];
      "nix.serverPath" = "${pkgs.nil}/bin/nil";
      "redhat.telemetry.enabled" = false;
      "cmake.configureOnOpen" = true;
      "github.copilot.enable" = {
        "*" = true;
        "yaml" = true;
        "plaintext" = true;
        "markdown" = true;
      };
    };
  };
}
