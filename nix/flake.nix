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

  outputs = inputs@{ self, nix-darwin, home-manager, nixpkgs, ... }:
  let
      system = "aarch64-darwin"; # Change to your system
      pkgs = import nixpkgs { inherit system; };
      
      # choose config file by system string (pure)
      systemConfig =  ./system/macosm1.nix;
  in
  {
    # --- macOS (nix-darwin) ---
    darwinConfigurations."home-air" =
        nix-darwin.lib.darwinSystem {
          inherit system;
          modules = [
            systemConfig
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.demis = ./home/home.nix;
            }
          ];
        };
  };
}
