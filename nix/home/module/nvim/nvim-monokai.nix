{ pkgs, lib, ... }:

let
  # Use packaged plugin if available; otherwise fetch from GitHub
  monokai-nvim =
    if pkgs.vimPlugins ? monokai-nvim then
      pkgs.vimPlugins.monokai-nvim
    else
      pkgs.vimUtils.buildVimPlugin {
        pname = "monokai.nvim";
        version = "soda";
        src = pkgs.fetchFromGitHub {
          owner = "tanvirtin";
          repo  = "monokai.nvim";
          rev   = "master";        # or pin a tag/commit
          sha256 = lib.fakeSha256; # build once to get the real hash, then replace
        };
      };
in
{
  # Only the theme bits live here
  programs.nvf.settings.vim = {
    options.termguicolors = true;

    # Install + configure the theme
    extraPlugins.monokai = {
      package = monokai-nvim;
      setup = ''
        require("monokai").setup { palette = require("monokai").soda }
        vim.cmd.colorscheme("monokai")
      '';
    };

    # Optional: keep backgrounds transparent for Ghostty
    luaConfigRC.transparent = ''
      for _, g in ipairs({
        "Normal","NormalNC","NormalFloat","FloatBorder",
        "SignColumn","LineNr","CursorLine","CursorLineNr","FoldColumn",
        "Pmenu","PmenuSel","TelescopeNormal","TelescopeBorder",
        "WhichKeyFloat","LazyNormal","MasonNormal",
      }) do
        vim.api.nvim_set_hl(0, g, { bg = "none" })
      end
    '';
  };
}
