# Ghostty: package on macOS only; config (symlink) on both.
{ config, dotfiles, lib, pkgs, ... }: {
  home.packages = lib.mkIf pkgs.stdenv.isDarwin (with pkgs; [ ghostty-bin ]);

  xdg.configFile."ghostty" = {
    source = "${dotfiles}/ghostty";
  };
}
