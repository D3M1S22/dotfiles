{ nvf, pkgs, ... }:
{
  imports = [
    nvf.homeManagerModules.default
    ./nvim-monokai.nix
    ./nvim-chadtree.nix
  ];

  home.packages = with pkgs; [
    taplo
  ];

  programs.nvf = {
    enable = true;
    settings.vim = {
      lsp = {
        enable = true;
        servers.taplo.enable = true;
      };
      extraPlugins.nvim-lspconfig = {
        package = pkgs.vimPlugins.nvim-lspconfig;
      };
    };
  };
}
