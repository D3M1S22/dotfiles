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
    configuration = { pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [ pkgs.neovim
        ];

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
        nix.enable = false;
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 6;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
    homeManagerConfiguration = 
    {
      home-manager.useGlobalPkgs = true;
      home-manager.users.demis = import ~/.config/nix/home.nix;
    };
    system = "aarch64-darwin";
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#damianos-MacBook-Air
    darwinConfigurations."home-air" = nix-darwin.lib.darwinSystem {
      inherit system;
      modules = [ configuration, home-manager.darwinModules.home-manager, homeManagerConfiguration ];
    };
  };
}
