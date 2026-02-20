{ config, dotfiles, lib, pkgs, ... }: {

  # walker setup theme
  xdg.configFile."walker" = lib.mkIf pkgs.stdenv.isLinux {
    source = "${dotfiles}/omarchy-style/walker";
  };

  #swayosd setup theme
  xdg.configFile."swayosd/style.css" = lib.mkIf pkgs.stdenv.isLinux {
    source = "${dotfiles}/omarchy-style/swayosd/style.css";
  };

  xdg.configFile."swayosd/theme" = lib.mkIf pkgs.stdenv.isLinux {
    source = "${dotfiles}/omarchy-style/swayosd/theme";
  };

}
