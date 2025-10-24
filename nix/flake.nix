{
  description = "Home flake nix";

  inputs = {
    ## nix urls
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    
   ## home-manger
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs"; 
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager }:
  let
    # Current system
    system = builtins.currentSystem;
    pkgs = import nixpkgs { inherit system; };

    # Detect platform
    isDarwin = pkgs.stdenv.isDarwin;
    isLinux = pkgs.stdenv.isLinux;
    isNixos = builtins.pathExists "/etc/NIXOS";

    # Select correct system config
    systemConfig =
      if isDarwin && pkgs.stdenv.isAarch64 then ./system/macosm1.nix
      else if isLinux then ./system/linux.nix
      else abort "Unsupported system: ${system}";
    
    homeManagerConfiguration = 
    {
      home-manager.useGlobalPkgs = true;
      home-manager.users.demis = import ~/.config/nix/home.nix;
    };
  in
  {
    # --- macOS (nix-darwin) ---
    darwinConfigurations."home-air" =
      if isDarwin then
        nix-darwin.lib.darwinSystem {
          inherit system;
          modules = [
            systemConfig
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.demis = import ./home/home.nix;
            }
          ];
        }
      else null;
    # # Build darwin flake using:
    # # $ darwin-rebuild build --flake .#damianos-MacBook-Air
    # darwinConfigurations."home-air" = nix-darwin.lib.darwinSystem {
    #   inherit system;
    #   modules = [ configuration, home-manager.darwinModules.home-manager, homeManagerConfiguration ];
    # };
  };
}
