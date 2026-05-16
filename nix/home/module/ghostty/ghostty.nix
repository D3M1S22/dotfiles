{ config, dotfiles, lib, pkgs, ... }: {
  home.packages = lib.mkIf pkgs.stdenv.isDarwin (with pkgs; [ ghostty-bin ]);

  # Map the static files explicitly
  xdg.configFile."ghostty/config".source = "${dotfiles}/ghostty/config";
  xdg.configFile."ghostty/style".source = "${dotfiles}/ghostty/style";
  xdg.configFile."ghostty/keybinds".source = "${dotfiles}/ghostty/keybinds";
  
  # Map the platform-specific file conditionally
  xdg.configFile."ghostty/platform.conf".source = 
    if pkgs.stdenv.isDarwin 
    then "${dotfiles}/ghostty/macos.conf" 
    else "${dotfiles}/ghostty/linux.conf";
}