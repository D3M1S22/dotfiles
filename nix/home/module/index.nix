# Shared and OS-specific imports. isDarwin comes from flake extraSpecialArgs (avoids pkgs in imports → no recursion).
{ lib, isDarwin ? false, isLinux ? false, ... }: {
  imports = [
    ./zsh/zsh.nix
    ./ghostty/ghostty.nix
    # ./thunderbird/thunderbird.nix
    ./cursor/cursor.nix
    ./yaak/yaak.nix
    ./direnv/direnv.nix
    ./tailscale/tailscale.nix #tailscale
  ]
  ++ lib.optionals isDarwin [
    # MAC_MODULES
    ./gh/gh.nix #gh
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
