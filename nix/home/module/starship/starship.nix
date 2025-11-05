{ config, dotfiles, pkgs, ... }: {
  home.packages = with pkgs; [
    starship
  ];
  ## loading starship config
  xdg.configFile."starship.toml".source = "${dotfiles}/starship/starship.toml";

  programs.starship.enable = true;

}