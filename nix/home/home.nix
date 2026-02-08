# Base home-manager config. homeDirectory is overridden per-platform in the flake.
{ lib, pkgs, ... }: {
  home.username = "demis";
  home.homeDirectory = lib.mkForce "/Users/demis";

  nixpkgs.config.allowUnfree = true;

  imports = [ ./module/index.nix ];

  home.stateVersion = "26.05";
}
