{ nvf, pkgs, ... }:
{
  imports = [
    nvf.homeManagerModules.default
    ./nvim-monokai.nix
    ./nvim-neotree.nix
  ];

  home.packages = with pkgs; [
    taplo
  ];

  programs.nvf = {
    enable = true;
    settings.vim = {
      luaConfigRC = {
        # Set the global leader key to Space
        leader-key = "vim.g.mapleader = ' '";
        window-navigation = ''
          -- Use Ctrl + hjkl to move between window splits
          vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Move to left window', silent = true })
          vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Move to right window', silent = true })
          vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Move to window below', silent = true })
          vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Move to window above', silent = true })

         -- NEW: Option-key navigation (Requires terminal config)
          -- Neovim uses <A-key> for Alt/Option
          vim.keymap.set('n', '<A-Left>', '<C-w>h', { desc = 'Move to left window', silent = true })
          vim.keymap.set('n', '<A-Right>', '<C-w>l', { desc = 'Move to right window', silent = true })
          vim.keymap.set('n', '<A-Down>', '<C-w>j', { desc = 'Move to window below', silent = true })
          vim.keymap.set('n', '<A-Up>', '<C-w>k', { desc = 'Move to window above', silent = true })
        '';
      };
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
