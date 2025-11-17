{ pkgs,... }:{
  
  ## neo-tree.nvim configuration

  programs.nvf.settings.vim = {
    lazy = true;
    lazy.plugins = {
      # These are required by neo-tree and must be
      "plenary.nvim" = {
        package = pkgs.vimPlugins.plenary-nvim;
      };

      "nui.nvim" = {
        package = pkgs.vimPlugins.nui-nvim;
      };
      "nvim-web-devicons" = {
        package = pkgs.vimPlugins.nvim-web-devicons;
      };
      "neo-tree.nvim" = {
        package = pkgs.vimPlugins.neo-tree-nvim;

        # 2. This tells nvf to generate: require('neo-tree').setup({})
        setupModule = "neo-tree";
        setupOpts = {
          # This section configures the keymaps *inside* the
          # neo-tree window itself.
          window = {
            mappings = {
              "l" = "open";           # Open file or folder
              "h" = "close_node";     # Close folder
              "<bs>" = "navigate_up"; # Go to parent directory
              "a" = "add";            # Add a file or directory
              "d" = "delete";         # Delete a file or directory
              "r" = "rename";         # Rename                
              "H" = "toggle_hidden";  # Toggle hidden files
              "?" = "show_help";      # Show the help popup
            };
          };
          
          # This ensures the tree follows your active buffer
          filesystem = {
            follow_current_file = {
              enabled = true;
            };
          };
        };
        # Define the global keymap to toggle the tree.
        keys =  [
          { mode = "n"; key = "<leader>e"; action = ":Neotree toggle<CR>"; desc = "Toggle Neo-tree"; }
        ];
      };
    };
  };
}