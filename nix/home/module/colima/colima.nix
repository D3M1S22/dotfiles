{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    colima
  ];
  # home.sessionVariables = {
  #   # Optional: set Docker socket path for Colima
  #   DOCKER_HOST = "unix://${config.home.homeDirectory}/.colima/docker.sock";
  # };
}