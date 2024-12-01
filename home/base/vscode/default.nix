{
  config,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [ nixfmt-rfc-style ];

  home.sessionVariables = {
    EDITOR = "${pkgs.vscode-launcher} --wait";
  };

  programs.vscode = {
    enable = true;
    enableExtensionUpdateCheck = false;
    enableUpdateCheck = false;
    extensions =
      pkgs.vscode-utils.extensionsFromVscodeMarketplace (builtins.fromJSON (
        builtins.readFile ./extensions.json
      )).extensions
      ++ (with pkgs.vscode-extensions; [
        eamodio.gitlens
        rust-lang.rust-analyzer
        ms-python.python
        redhat.vscode-yaml
        hashicorp.terraform
        matthewpi.caddyfile-support
        ms-vscode.makefile-tools
      ]);

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
        key = "ctrl+j";
        command = "workbench.action.quickOpenSelectNext";
        when = "inQuickOpen";
      }
      {
        key = "ctrl+k";
        command = "workbench.action.quickOpenSelectPrevious";
        when = "inQuickOpen";
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
      "gopls" = {
        "ui.semanticTokens" = true;
      };
      "jsonnet.languageServer.lint" = true;
      "jsonnet.languageServer.pathToBinary" = "${pkgs.jsonnet-language-server}/bin/jsonnet-language-server";
      "terraform.languageServer.path" = "${pkgs.terraform-lsp}/bin/terraform-lsp";
      "[terraform]" = {
        "editor.defaultFormatter" = "hashicorp.terraform";
        "editor.formatOnSave" = true;
        "editor.formatOnSaveMode" = "file";
      };
      "[terraform-vars]" = {
        "editor.defaultFormatter" = "hashicorp.terraform";
        "editor.formatOnSave" = true;
        "editor.formatOnSaveMode" = "file";
      };

      "caddyfile.executable" = "${pkgs.caddy}/bin/caddy";

      "keyboard.dispatch" = "keyCode";

      "extensions.experimental.affinity" = {
        "vscodevim.vim" = 1;
      };
      "vim.incsearch" = true;
      "vim.autoSwitchInputMethod.defaultIM" = "1";
      "vim.autoSwitchInputMethod.enable" = true;
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
        "<C-p>" = false;
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
        {
          before = [
            "g"
            "i"
          ];
          commands = [ "references-view.findImplementations" ];
        }
        {
          before = [
            "g"
            "p"
            "i"
          ];
          commands = [ "editor.action.peekImplementation" ];
        }
        {
          before = [
            "g"
            "r"
          ];
          commands = [ "references-view.findReferences" ];
        }
        {
          before = [
            "<leader>"
            "i"
          ];
          commands = [ "go.impl.cursor" ];
        }
        {
          before = [
            "<leader>"
            "l"
          ];
          commands = [ "workbench.action.nextEditor" ];
        }
        {
          before = [
            "<leader>"
            "h"
          ];
          commands = [ "workbench.action.previousEditor" ];
        }
        {
          before = [
            "<leader>"
            "p"
          ];
          commands = [ "workbench.action.quickOpen" ];
        }
        {
          before = [
            "<leader>"
            "g"
            "f"
          ];
          commands = [ "workbench.action.findInFiles" ];
        }
        {
          before = [
            "<leader>"
            "f"
          ];
          commands = [ "actions.find" ];
        }
        {
          before = [
            "\\"
            "r"
          ];
          commands = [ "editor.action.formatDocument" ];
        }
      ];
      "vim.visualstar" = true;

      "editor.fontFamily" = "monospace, 'SF Mono', 'Material-Design-Iconic-Font', feather";
      "editor.fontLigatures" = false;
      "editor.fontSize" = 12;
      "editor.inlineSuggest.enabled" = true;
      "editor.lineHeight" = 22;
      "editor.lineNumbers" = "relative";
      "editor.semanticHighlighting.enabled" = true;

      "terminal.integrated.commandsToSkipShell" = [ "-workbench.action.quickOpen" ];
      "terminal.integrated.fontFamily" = "monospace, 'SF Mono', 'Hasklug Nerd Font'";
      "terminal.integrated.fontWeight" = "normal";
      "terminal.integrated.fontSize" = 12;
      "terminal.integrated.fontWeightBold" = 600;
      "terminal.integrated.shellIntegration.enabled" = true;
      "terminal.integrated.stickyScroll.enabled" = false;

      "window.menuBarVisibility" = "toggle";
      "window.newWindowDimensions" = "inherit";
      "window.zoomLevel" = 1;

      "workbench.colorTheme" = "Material Theme Darker High Contrast";
      "workbench.iconTheme" = "eq-material-theme-icons-light";

      "editor.tokenColorCustomizations" = {
        "[Material Theme Darker High Contrast]" = {
          "textMateRules" = [
            {
              "scope" = [ "variable" ];
              "settings" = {
                "foreground" = "${config.scheme.withHashtag.base0E}";
              };
            }
            {
              "scope" = [ "variable.parameter" ];
              "settings" = {
                "foreground" = "${config.scheme.withHashtag.base0F}";
              };
            }
          ];
        };
      };

      "nix.enableLanguageServer" = true;
      "nix.serverSettings.nil.formatting.command" = [ "nixfmt" ];
      "nix.serverPath" = "${pkgs.nil}/bin/nil";
      "redhat.telemetry.enabled" = false;
      "cmake.configureOnOpen" = true;
      "github.copilot.enable" = {
        "*" = true;
        "yaml" = true;
        "plaintext" = true;
        "markdown" = true;
      };
      "github.copilot.editor.enableAutoCompletions" = true;
      "gitlens.ai.experimental.provider" = "openai";
      "gitlens.ai.experimental.openai.model" = "gpt-3.5-turbo";
      "[dockerfile]" = {
        "editor.defaultFormatter" = "ms-azuretools.vscode-docker";
      };
    };
  };
}
