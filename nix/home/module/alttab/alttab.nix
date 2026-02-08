# Darwin-only (included only when isDarwin in index.nix).
{ pkgs, ... }: {
  home.packages = with pkgs; [ alt-tab-macos ];
}
