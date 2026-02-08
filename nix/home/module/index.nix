# Shared and OS-specific imports. See EXAMPLE-CONDITIONAL-IMPORTS.nix for patterns.
# Do not use pkgs in `imports` (causes infinite recursion in nix-darwin). Use mkIf inside modules instead.
{ lib, ... }: {
  imports = [
    ./zsh/zsh.nix
    ./ghostty/ghostty.nix
    ./starship/starship.nix
    ./nvim/nvim.nix
    # ./thunderbird/thunderbird.nix
    ./cursor/cursor.nix
    ./yaak/yaak.nix
    ./direnv/direnv.nix
    ./alttab/alttab.nix
    ./orbstack/orbstack.nix
  ];
}
