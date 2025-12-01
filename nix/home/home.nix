{ lib, ... }: {
  home.username = "demis";
  home.homeDirectory = lib.mkForce "/Users/demis";
  # ✅ must be absolute path
  
  nixpkgs.config = {
    # The predicate function checks if the package name is in the allowed list.
    allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "code-cursor"         
    ];
  };
  
  imports = [ ./module/index.nix ];

  home.stateVersion = "26.05";
  
}
