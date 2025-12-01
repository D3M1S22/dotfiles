{ lib, ... }: {
  home.username = "demis";
  home.homeDirectory = lib.mkForce "/Users/demis";
  # ✅ must be absolute path
  
 nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
             "cursor"
           ];
         
  
  imports = [ ./module/index.nix ];

  home.stateVersion = "26.05";
  
}
