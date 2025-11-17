## nvim-copilot-chat configuration

{ pkgs,... }:{
  programs.nvf.settings.vim = {
    # CopilotChat needs plenary
    lazy = true;
    dependencies = [ pkgs.vimPlugins.plenary-nvim ];
    extraPlugins = {

      copilotchat = {
        # If your nixpkgs doesn’t have this packaged, see Option B below.
        package = pkgs.vimUtils.buildVimPlugin {
          pname = "CopilotChat.nvim";
          version = "git-2025-11-17";
          src = pkgs.fetchFromGitHub {
            owner = "CopilotC-Nvim";
            repo  = "CopilotChat.nvim";
            # Pin something you trust (replace with a commit or tag you want)
            rev    = "main";
            sha256 = "sha256-sT4UnxLvfuHZxkrMjFaUNVyun7sxwax83O/QB3f7fQE="; # build once to get real hash
          };
        };

        # Configure the plugin (OpenAI example)
        setup = ''
          require("CopilotChat").setup({
            model = "gpt-4o",
            -- adapter = "openai", -- uncomment if you need to force the provider
          })
        '';
      };
    };

    # nice to have
    options.termguicolors = true;
  };
}
