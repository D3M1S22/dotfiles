{ pkgs, ... }:
{
  programs.nvf.settings.vim = {
    lazy.plugins = {
      "CopilotChat.nvim" = {
        package = pkgs.vimPlugins.CopilotChat-nvim;
        setupOpts = {
          window = {
            layout = "float"; # Other options: "vertical", "horizontal"
            border = "rounded";
            title = " AI Assistant";
            zindex = 100;
          };
          headers = {
            user = " You: ";
            assistant = " Copilot: ";
            tool = " Tool: ";
          };
          chat = {
            keymaps = {
              # This changes the submit key in INSERT mode.
              # The default is "<C-s>" 
              submit_normal = "<A-s>"; # (Ctrl+Enter)

              # You can also change the NORMAL mode submit key
              # submit_normal = "<CR>"; # (This is the default):
            };
          };
          separator = "━━";
          show_folds = false;
        };
        keys = [
          {
            key = "<leader>ct";
            action = "<cmd>CopilotChatToggle<cr>"; # Toggle CopilotChat
            desc = "CopilotChat - Toggle";
            mode = "n"; # Normal mode
          }
          {
            key = "<leader>ce";
            action = "<cmd>CopilotChatExplain<cr>"; # Explain selection [11, 12]
            desc = "CopilotChat - Explain";
            mode = "v"; # Visual mode
          }
          # Add more keymaps as desired, e.g., for Tests, Refactor, etc.
          # { key = "<leader>ct"; action = "<cmd>CopilotChatTests<cr>"; desc = "CopilotChat - Tests"; mode = "v"; }
        ];
      };
    };
  };
}
