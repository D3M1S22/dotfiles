{ pkgs, lib, ... }: {
  environment.systemPackages = with pkgs;
  [
    home-manager
  ];

  users.users.demis.shell = pkgs.zsh;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = 6;
  # hostPlatform is set by nix-darwin from the flake's system (single source of truth)
  nix.enable = false;

  programs.zsh = {
    enable = true;
  };
}
