{ config, dotfiles, lib, pkgs, ... }: {
  home.packages = lib.mkIf pkgs.stdenv.isDarwin (with pkgs; [ ghostty-bin ]);

  xdg.configFile."walker" =  pkgs.stdenv.isLinux {
    source = "${dotfiles}/omarchy-style/walker";
  };


}
