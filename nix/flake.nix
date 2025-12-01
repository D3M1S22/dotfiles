{
  description = "Home flake nix";

  inputs = {
    ## nix urls
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    # nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-25.11-darwin";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    
   ## home-manger
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";


    ## dotfiles
    dotfiles = {
      url = "github:D3M1S22/dotfiles";
      flake = false;
    };
	
    ## nvim config nvf [documentation](https://notashelf.github.io/nvf)
    nvf.url = "github:notashelf/nvf";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager, dotfiles, nvf }:
  let
      system = "aarch64-darwin"; # Change to your system
      pkgs = import nixpkgs { inherit system; };
      isDarwin = pkgs.stdenv.isDarwin;
      isLinux = pkgs.stdenv.isLinux;

      # choose config file by system string (pure)
      systemConfig = if system == "aarch64-darwin" then ./system/macosm1.nix
                     else if system == "x86_64-darwin" then ./system/macosintel.nix
                     else if system == "x86_64-linux" then ./system/linux.nix
                     else abort "Unsupported system: ${system}";
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
              system.configurationRevision = self.rev or self.dirtyRev or null;
              home-manager.useGlobalPkgs = false;
              home-manager.useUserPackages = false;

              home-manager.backupFileExtension = "preHM";  # e.g. makes ~/.zshrc.preHM
              home-manager.extraSpecialArgs = { inherit dotfiles self nvf; };
              
              # anchor to flake root; independent of CWD
              home-manager.users.demis = import (self + /home/home.nix);
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
