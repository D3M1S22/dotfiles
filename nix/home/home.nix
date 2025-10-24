{ config, pkgs, ... }:

{
  # --- User metadata ---
  home.username = "demis";
  home.homeDirectory = "/Users/demis";

  # Must match your nixpkgs / Home-Manager version
  home.stateVersion = "24.05";

  # --- Packages installed only for this user ---
  home.packages = with pkgs; [
    neovim          # Editor
  ];

#   # --- Import small config modules ---
#   imports = [
#     ./modules/zsh.nix
#     ./modules/starship.nix
#   ];

#   # --- Enable programs managed by Home Manager ---
#   programs.git = {
#     enable = true;
#     userName  = "Damiano Shushku";
#     userEmail = "you@example.com";
#     extraConfig = {
#       core.editor = "nvim";
#       color.ui = true;
#     };
#   };

#   programs.neovim = {
#     enable = true;
#     viAlias = true;
#     vimAlias = true;
#   };

#   # --- Example: environment variables ---
#   home.sessionVariables = {
#     EDITOR = "nvim";
#     LANG   = "en_US.UTF-8";
#   };

#   # --- Example: custom shell aliases ---
#   programs.zsh.shellAliases = {
#     ll = "ls -lah";
#     gs = "git status";
#     rebuild = "sudo darwin-rebuild switch --flake ~/dotfiles#home-air";
#   };
}
