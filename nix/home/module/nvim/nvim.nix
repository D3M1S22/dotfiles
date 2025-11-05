{ nvf, pkgs, ... }:
{
  imports = [
    nvf.homeManagerModules.default
    ./nvim-monokai.nix
  ];

  programs.nvf = {
    enable = true;
    settings.vim = {
      vimAlias = true;
      viAlias  = false;
      # … any other nvf settings you have …
    };
  };
}
