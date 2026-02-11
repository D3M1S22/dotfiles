# Base home-manager config.
{ lib, pkgs, ... }: {
  home.username = "demis";
  home.homeDirectory = lib.mkForce (
    if pkgs.stdenv.isDarwin then "/Users/demis"
    else "/home/demis"
  );

  nixpkgs.config.allowUnfree = true;

  imports = [ ./module/index.nix ];

  programs.home-manager.enable = lib.mkIf pkgs.stdenv.isLinux true;

  targets.genericLinux.enable = lib.mkIf pkgs.stdenv.isLinux true;

  home.stateVersion = "26.05";
}
