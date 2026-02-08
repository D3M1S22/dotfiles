# Shared and OS-specific imports. See EXAMPLE-CONDITIONAL-IMPORTS.nix for patterns.
{ lib, pkgs, ... }: {
  imports = [
    ./zsh/zsh.nix
    ./ghostty/ghostty.nix
    ./starship/starship.nix
    ./nvim/nvim.nix
    # ./thunderbird/thunderbird.nix
    ./cursor/cursor.nix
    ./yaak/yaak.nix
    ./direnv/direnv.nix
  ]
  # Darwin-only (macOS): uncomment linux-only block below when you add Linux-specific modules
  ++ lib.optionals pkgs.stdenv.isDarwin [
    ./alttab/alttab.nix
    ./orbstack/orbstack.nix
  ];
  # ++ lib.optionals pkgs.stdenv.isLinux [
  #   ./some-linux-only/some-linux-only.nix
  # ];
}
