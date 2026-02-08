# NixOS system module (for nixosConfigurations).
# Parallel to system/macosm1.nix for Linux.
{ pkgs, lib, ... }: {
  environment.systemPackages = with pkgs; [
    home-manager
  ];

  users.users.demis = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" ];  # comment if user doesn't need sudo
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "24.11";

  programs.zsh.enable = true;
}
