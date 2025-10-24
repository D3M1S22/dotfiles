{ config, pkgs, lib, ... }: {
  home.username = "demis";
  home.homeDirectory = lib.mkForce "/Users/demis";  # ✅ must be absolute path
  home.stateVersion = "24.05";          # match nixpkgs version

  home.packages = with pkgs;
  [ 
    pkgs.neovim
  ];
  
  programs.home-manager.enable = true;
}

