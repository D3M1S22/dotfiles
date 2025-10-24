{ pkgs, ... }: {
  environment.systemPackages = with pkgs;
  [
    home-manager
  ];

  # --- ADD THIS BLOCK ---
  # Tell nix-darwin that 'demis' uses zsh
  users.users.demis.shell = pkgs.zsh;
  # ---------------------

  nix.settings.experimental-features = "nix-command flakes";
  system.stateVersion = 6;
  nixpkgs.hostPlatform = "aarch64-darwin";
  nix.enable = false;
  
  # Keep this from the last fix
  programs.zsh = {
    enable = true;
  };
}