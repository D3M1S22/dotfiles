{ pkgs, lib, ... }: {
  environment.systemPackages = with pkgs;
  [
    home-manager
  ];

  users.users.demis.shell = pkgs.zsh;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = 6;
  nixpkgs.hostPlatform = "aarch64-darwin";
  nix.enable = false;

  programs.zsh = {
    enable = true;
  };
}
