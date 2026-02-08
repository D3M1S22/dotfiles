# Ghostty: symlink the whole config dir from dotfiles (original simple approach).
{ config, dotfiles, pkgs, ... }: {
  home.packages = with pkgs; [ ghostty-bin ];

  xdg.configFile."ghostty" = {
    source = "${dotfiles}/ghostty";
  };
}
