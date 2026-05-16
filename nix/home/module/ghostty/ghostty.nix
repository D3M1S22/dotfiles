# Ghostty: package on macOS only; config (symlink) on both.
{ config, dotfiles, lib, pkgs, ... }: {
  home.packages = lib.mkIf pkgs.stdenv.isDarwin (with pkgs; [ ghostty-bin ]);

  # 1. Symlink your shared directory files (style, keybinds, etc.)
  xdg.configFile."ghostty" = {
    source = "${dotfiles}/ghostty";
  };

  # 2. Declaratively drop the platform config right next to them
  home.file.".config/ghostty/config.platform" = {
    text = if pkgs.stdenv.isDarwin 
           then "config-file=macos.conf" 
           else "config-file=linux.conf";
  };
}