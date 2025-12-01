{ lib, pkgs, ... }: {
  home.username = "demis";
  home.homeDirectory = lib.mkForce "/Users/demis";
  # ✅ must be absolute path

  nixpkgs.config.allowUnfree = true;
  
  imports = [ ./module/index.nix ];

  home.stateVersion = "26.05";
  
}
