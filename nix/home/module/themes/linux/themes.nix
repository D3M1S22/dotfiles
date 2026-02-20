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
  
  xdg.configFile."hypr/hyprland.conf" = lib.mkIf pkgs.stdenv.isLinux {
    source = "${dotfiles}/omarchy-style/hypr/hyprland.conf";
  };

  xdg.configFile."hypr/hyprtheme.conf" = lib.mkIf pkgs.stdenv.isLinux {
    text = ''
      general {
          col.active_border = rgba(ABA0F2ee) rgba(F28B66ee) 45deg
          col.inactive_border = rgba(0a122088)
      }
    '';
  };

  xdg.configFile."waybar/style.css" = lib.mkIf pkgs.stdenv.isLinux {
    source = "${dotfiles}/omarchy-style/waybar/waybar.css";
  };

}
