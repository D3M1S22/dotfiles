{ config, pkgs, lib, dotfiles, ... }: {
  home.username = "demis";
  home.homeDirectory = lib.mkForce "/Users/demis";
  # ✅ must be absolute path

  home.packages = with pkgs; [
    neovim
    alt-tab-macos
    starship
    ghostty-bin
    # alttab
  ];
  
  ## loading zsh config
  home.file.".zshrc".source   = "${dotfiles}/zsh/.zshrc";
  ## loading ghostty config
   xdg.configFile."ghostty" = {
    source = "${dotfiles}/ghostty";
    # optional: make a real dir with per-file symlinks
    # recursive = true;
  };
  
  ## loading starship config
  xdg.configFile."starship.toml".source = "${dotfiles}/starship/starship.toml";

  home.stateVersion = "25.11";
  
  programs.starship = {
    enable = true;
  };
}
