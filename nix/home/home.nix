{ config, pkgs, lib, dotfiles, ... }: {
  home.username = "demis";
  home.homeDirectory = lib.mkForce "/Users/demis";
  # ✅ must be absolute path

  home.packages = with pkgs; [
    neovim
    alt-tab-macos
    starship
    ghostty
    # alttab
  ];
  
  ## loading zsh config
  home.file.".zshrc".source   = "${dotfiles}/zsh/.zshrc";
  ## loading ghostty config
  xdg.configFile."ghostty/config".source = "${dotfiles}/ghostty/config";
  
  home.stateVersion = "25.11";
  
  programs.starship = {
    enable = true;
  };
  # --- REMOVE THIS LINE ---
  # programs.home-manager.enable = true;          # Not needed with nix-darwin module
  
}
