{ pkgs, ... }:

let
  copilotchat-nvim = pkgs.vimUtils.buildVimPlugin {
    pname = "CopilotChat.nvim";
    version = "git-2025-11-17";
    src = pkgs.fetchFromGitHub {
      owner = "CopilotC-Nvim";
      repo  = "CopilotChat.nvim";
      rev   = "main";
      sha256 = "sha256-sT4UnxLvfuHZxkrMjFaUNVyun7sxwax83O/QB3f7fQE=";
    };
  };
in
{
  programs.nvf.settings.vim = {
    lazy.plugins = {
      "CopilotChat.nvim" = {
        package = copilotchat-nvim;
        setupModule = "CopilotChat";
        setupOpts = {
          model = "gpt-4o";
        };
        keys = [
          { mode = "n"; key = "<leader>cc"; action = ":CopilotChat<CR>"; desc = "Toggle CopilotChat"; }
          { mode = "v"; key = "<leader>cc"; action = ":CopilotChat<CR>"; desc = "Toggle CopilotChat"; }
        ];
      };
    };

    options.termguicolors = true;
  };
}
