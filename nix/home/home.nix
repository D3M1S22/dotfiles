{ lib, ... }: {
  home.username = "demis";
  home.homeDirectory = lib.mkForce "/Users/demis";
  # ✅ must be absolute path

  imports = [ ./module/index.nix ];

  home.stateVersion = "26.05";
  
}
