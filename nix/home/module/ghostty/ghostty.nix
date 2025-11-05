{ config, dotfiles, pkgs }: {
  
  home.packages = with pkgs; [
    ghostty-bin
  ];
  ## loading ghostty config
  xdg.configFile."ghostty" = {
    source = "${dotfiles}/ghostty";
    # optional: make a real dir with per-file symlinks
    # recursive = true;
  };
}