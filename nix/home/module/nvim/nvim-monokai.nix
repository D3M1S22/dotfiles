{ pkgs, lib, ... }:

let
  monokai-nvim = pkgs.vimUtils.buildVimPlugin {
    pname = "monokai.nvim";
    version = "soda-<date-or-rev>";
    src = pkgs.fetchFromGitHub {
      owner = "tanvirtin";
      repo  = "monokai.nvim";
      rev   = "<pin a commit or tag>";  # don't leave 'master' if you want reproducibility
      sha256 = "sha256-Q6+la2P2L1QmdsRKszBBMee8oLXHwdJGWjG/FMMFgT0=";  # <-- from the error
    };
  };
in {
  programs.nvf.settings.vim.extraPlugins.monokai = {
    package = monokai-nvim;
    setup = ''
      require("monokai").setup { palette = require("monokai").soda }
      vim.cmd.colorscheme("monokai")
    '';
  };
}