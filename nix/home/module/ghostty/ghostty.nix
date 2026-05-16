{ config, dotfiles, lib, pkgs, ... }: {
  # Only install the ghostty package on macOS (since it's home-manager standalone on Linux)
  home.packages = lib.mkIf pkgs.stdenv.isDarwin (with pkgs; [ ghostty-bin ]);

  # 1. Symlink the shared files (style, keybinds, and base config)
  xdg.configFile."ghostty" = {
    source = "${dotfiles}/ghostty";
  };

  # 2. Inject the OS-specific include statement dynamically into a local override file
  xdg.configFile."ghostty/config.platform" = {
    text = if pkgs.stdenv.isDarwin 
           then "config-file=macos.conf" 
           else "config-file=linux.conf";
  };
}