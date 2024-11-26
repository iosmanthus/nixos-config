{ pkgs, lib, ... }:
{
  programs.neovim = {
    enable = true;
    plugins = [
      {
        plugin = pkgs.vimUtils.buildVimPlugin {
          name = "base16-nvim";
          src = pkgs.fetchFromGitHub {
            owner = "RRethy";
            repo = "base16-nvim";
            rev = "6ac181b5733518040a33017dde654059cd771b7c";
            sha256 = "sha256-GRF/6AobXHamw8TZ3FjL7SI6ulcpwpcohsIuZeCSh2A=";
          };
        };
        type = "lua";
        config = ''
          if not vim.g.vscode then
            vim.cmd('colorscheme base16-material-darker')
          end
        '';
      }
      {
        plugin = pkgs.vimUtils.buildVimPlugin {
          name = "im-select.nvim";
          src = pkgs.fetchFromGitHub {
            owner = "keaising";
            repo = "im-select.nvim";
            rev = "6425bea7bbacbdde71538b6d9580c1f7b0a5a010";
            sha256 = "sha256-sE3ybP3Y+NcdUQWjaqpWSDRacUVbRkeV/fGYdPIjIqg=";
          };
        };
        type = "lua";
        config = ''
          require('im_select').setup({})
        '';
      }
      {
        plugin = pkgs.vimUtils.buildVimPlugin {
          name = "vim-visual-multi";
          src = pkgs.fetchFromGitHub {
            owner = "mg979";
            repo = "vim-visual-multi";
            rev = "a6975e7c1ee157615bbc80fc25e4392f71c344d4";
            sha256 = "sha256-KzBWkB/PYph6OfuF0GgNFYgqUAwMYbQQZbaaG9XuWZY=";
          };
        };
        type = "viml";
        config = ''
          let g:VM_maps = {}
          let g:VM_maps['Find Under'] = '<C-d>'
          let g:VM_maps['Find Subword Under'] = '<C-d>'
        '';
      }
    ];
    extraLuaConfig = ''
      vim.g.mapleader = " "
      vim.g.maplocalleader = "\\"
    '';
  };
}
