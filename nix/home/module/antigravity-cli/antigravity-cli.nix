{ config, pkgs, lib, ... }:

{
  # Configuration for antigravity-cli
  home.packages = with pkgs; [
    antigravity-cli
  ];
}
