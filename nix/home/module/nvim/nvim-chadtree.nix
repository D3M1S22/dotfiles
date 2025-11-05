{ pkgs, ... }:
{
  programs.nvf.settings.vim = {
    startPlugins = with pkgs.vimPlugins; [ lazy-nvim ]; # bootstrap Lazy
    options.luaConfigRC = ''
      -- Lazy userspace plugin manager
      require("lazy").setup({
        {
          "ms-jpq/chadtree",
          branch = "chad",
          -- Let CHADTree fetch its Python deps into a local venv:
          build = "python3 -m chadtree deps",
          config = function()
            vim.g.chadtree_settings = {
              ["view.open_direction"] = "left",
              ["view.width"] = 34,
              ["ignore.name_exact"] = { ".git", "node_modules", "dist", "target" },
            }
            vim.keymap.set("n", "<leader>e", "<cmd>CHADopen<CR>",
              { silent = true, desc = "CHADTree: toggle" })
          end,
        },
        { "nvim-tree/nvim-web-devicons" },
      })
    '';
  };

  home.packages = with pkgs; [
    (python3.withPackages (ps: with ps; [ pip virtualenv pynvim ]))
    trash-cli
  ];
}
