## nvim-copilot-chat configuration

{ pkgs,... }:{
  programs.nvf.settings.vim = {
    lazy.plugins = {
      "CopilotC-Nvim/CopilotChat.nvim" = {
        package = pkgs.vimPlugins.copilotchat-nvim;

        # This tells nvf to generate: require('copilot-chat').setup({})
        setupModule = "copilot-chat";
        setupOpts = {
          chat = {
            welcome_message = "Hello! I'm your AI assistant. How can I help you today?";
            loading_text = "Loading, please wait...";
            question_sign = "❓ ";
            answer_sign = "💡 ";
          };
          window = {
            border = {
              style = "rounded";
              text = {
                top = " Copilot Chat ";
              };
            };
          };
        };

        # Define the global keymap to open Copilot Chat.
        keys =  [
          { mode = "n"; key = "<leader>cc"; action = ":CopilotChat<CR>"; desc = "Open Copilot Chat"; }
        ];
      };
    };
  };
}
