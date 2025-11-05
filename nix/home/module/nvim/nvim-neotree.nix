{ pkgs,... }:

{
  #... other home-manager settings...

  programs.nvf = {
    enable = true;
    vim = {
      #... other nvf settings like viAlias, etc....

      # nvf uses lazy.nvim under the hood. This is the API
      # for adding plugins.
      lazy.plugins = {

        # === DEPENDENCIES for neo-tree ===
        # These are required by neo-tree and must be
        # available in the Nix-built environment.

        # 1. Required utility library [2, 3, 4]
        "plenary.nvim" = {
          package = pkgs.vimPlugins.plenary-nvim;
        };

        # 2. Required UI component library [2, 3, 4]
        "nui.nvim" = {
          package = pkgs.vimPlugins.nui-nvim;
        };

        # 3. Recommended for file icons [3, 5, 4]
        "nvim-web-devicons" = {
          package = pkgs.vimPlugins.nvim-web-devicons;
        };


        # === The neo-tree plugin itself ===
        "neo-tree.nvim" = {
          # 1. The Nix package for the plugin [6]
          package = pkgs.vimPlugins.neo-tree-nvim;

          # 2. This tells nvf to generate: require('neo-tree').setup({}) 
          setupModule = "neo-tree";

          # 3. (Optional) Pass a Nix attrset as setup options.
          # nvf translates this to the Lua table for setup().
          setupOpts = {
            # This empty table uses neo-tree's defaults.
            # Add any config options from the neo-tree docs here.
            # Example:
            # view = {
            #   width = 35;
            # };
            # filesystem = {
            #   follow_current_file = true;
            # };
          };

          # 4. (Optional) Lazy-load the plugin on a keymap or command 
          keys =;
          cmd = [ "Neotree" ];
        };

        #... add your other plugins here...

      };
    };
  };

  #... other home-manager settings...
}