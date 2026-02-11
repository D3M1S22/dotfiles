# Ghostty: package on macOS only; config (symlink) on both.
{ config, dotfiles, lib, pkgs, ... }: {
  home.packages = lib.mkIf pkgs.stdenv.isDarwin (with pkgs; [ ghostty-bin ]);

  xdg.configFile."ghostty" = {
    source = "${dotfiles}/ghostty";
  };

  xdg.configFile."ghostty/linux.conf" = lib.mkIf pkgs.stdenv.isLinux {
    text = ''
      command = ${config.home.homeDirectory}/.nix-profile/bin/zsh
    '';
  };
}
