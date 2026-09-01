{ config, pkgs, lib, ... }:

{
  # Configuration for gh
  home.packages = with pkgs; [
    gh
  ];
}
