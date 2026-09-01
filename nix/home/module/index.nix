# Shared and OS-specific imports. isDarwin comes from flake extraSpecialArgs (avoids pkgs in imports → no recursion).
{ lib, isDarwin ? false, isLinux ? false, ... }: {
  imports = [
    # UNIVERSAL_MODULES
    ./zsh/zsh.nix #zsh
    ./ghostty/ghostty.nix #ghostty
    # ./thunderbird/thunderbird.nix #thunderbird
    ./cursor/cursor.nix #cursor
    ./yaak/yaak.nix #yaak
    ./direnv/direnv.nix #direnv
  ]
  ++ lib.optionals isDarwin [
    # MAC_MODULES
    # ./nvim/nvim.nix #nvim
    ./starship/starship.nix #starship
    ./alttab/alttab.nix #alttab
    ./orbstack/orbstack.nix #orbstack
  ]
  ++ lib.optionals isLinux [
    # LINUX_MODULES
    ./nordvpn/nordvpn.nix #nordvpn
    ./zen-browser/zen.nix #zen
    ./android-studio/android-studio.nix #android-studio
    # ./themes/linux/themes.nix #themes
  ];
}
