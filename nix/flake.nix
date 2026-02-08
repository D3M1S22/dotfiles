{
  description = "Home flake: nix-darwin (macOS) + home-manager (shared)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    dotfiles = {
      url = "github:D3M1S22/dotfiles";
      flake = false;
    };

    nvf.url = "github:notashelf/nvf";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager, dotfiles, nvf }:
  let
    lib = nixpkgs.lib;

    # Single source of truth: config name -> system.
    darwinHosts = {
      "home-air" = "aarch64-darwin";
      # "home-air-intel" = "x86_64-darwin";
    };
    linuxHosts = {
      "home-linux" = "x86_64-linux";
      # "home-linux-aarch64" = "aarch64-linux";
    };

    systemConfig = system:
      if system == "aarch64-darwin" then ./system/macosm1.nix
      else if system == "x86_64-darwin" then ./system/macosintel.nix
      else if system == "x86_64-linux" then ./system/linux.nix
      else if system == "aarch64-linux" then ./system/linux.nix
      else abort "Unsupported system: ${system}";

    mkDarwin = name: system: nix-darwin.lib.darwinSystem {
      inherit system;
      modules = [
        (systemConfig system)
        home-manager.darwinModules.home-manager
        {
          system.configurationRevision = self.rev or self.dirtyRev or null;
          home-manager.useGlobalPkgs = false;
          home-manager.useUserPackages = false;
          home-manager.backupFileExtension = "preHM";
          home-manager.extraSpecialArgs = { inherit dotfiles self nvf; isDarwin = true; };
          home-manager.users.demis = import (self + /home/home.nix);
        }
      ];
    };

    mkHome = name: system: home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.${system};
      extraSpecialArgs = { inherit dotfiles self nvf; isDarwin = false; };
      modules = [
        ({ ... }: {
          home.stateVersion = "26.05";
        })
        (import (self + /home/home.nix))
      ];
    };
    # Run home-manager switch using this flake's home-manager (no prior install).
    mkSwitchApp = system: name: let
      hm = home-manager.packages.${system}.default;
      script = nixpkgs.legacyPackages.${system}.writeShellScript "hm-switch-${name}" ''
        export NIX_CONFIG="experimental-features = nix-command flakes"
        FLAKE="''${NIX_FLAKE_PATH:-$HOME/dotfiles/nix}"
        exec "${hm}/bin/home-manager" switch --flake "$FLAKE#${name}" "$@"
      '';
    in { type = "app"; program = "${script}"; };
  in
  {
    darwinConfigurations = lib.mapAttrs mkDarwin darwinHosts;

    homeConfigurations = lib.mapAttrs mkHome linuxHosts;

    # First-time Linux (no home-manager installed): nix run .#switch-linux
    apps.x86_64-linux.switch-linux = mkSwitchApp "x86_64-linux" "home-linux";
    apps.aarch64-linux.switch-linux = mkSwitchApp "aarch64-linux" "home-linux";
  };
}
