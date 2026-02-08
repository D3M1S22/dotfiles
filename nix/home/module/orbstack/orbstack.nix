{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # docker
    # docker-compose
    orbstack
  ];
  # home.sessionVariables = {
  #   # Optional: set Docker socket path for Colima
  #   DOCKER_HOST = "unix://${config.home.homeDirectory}/.colima/docker.sock";
  # };
}