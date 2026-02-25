# Shared and OS-specific imports. isDarwin comes from flake extraSpecialArgs (avoids pkgs in imports → no recursion).
{ lib, isDarwin ? false, isLinux ? false, ... }: {
  imports = [
    ./zsh/zsh.nix
    ./ghostty/ghostty.nix
    # ./thunderbird/thunderbird.nix
    ./cursor/cursor.nix
    ./yaak/yaak.nix
    ./direnv/direnv.nix
  ]
  ++ lib.optionals isDarwin [
    ./nvim/nvim.nix
    ./starship/starship.nix
    ./alttab/alttab.nix
    ./orbstack/orbstack.nix
  ]
  ++ lib.optionals isLinux [
    ./zen-browser/zen.nix
    ./android-studio/android-studio.nix
    # ./themes/linux/themes.nix
  ];
}
