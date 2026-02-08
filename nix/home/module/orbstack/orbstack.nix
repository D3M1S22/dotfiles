# Darwin-only: no-op on Linux (avoids using pkgs in index.nix imports → infinite recursion).
{ config, lib, pkgs, ... }: lib.mkIf pkgs.stdenv.isDarwin {
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