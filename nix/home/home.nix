{ config, pkgs, lib, ... }: {
  home.username = "demis";
  home.homeDirectory = lib.mkForce "/Users/demis";
  # ✅ must be absolute path

  home.packages = with pkgs; [
    pkgs.neovim
  ];

  home.stateVersion = "25.11";
  
  # --- REMOVE THIS LINE ---
  # programs.home-manager.enable = true;          # Not needed with nix-darwin module
}