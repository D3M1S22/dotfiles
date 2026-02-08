# Darwin-only: no-op on Linux (avoids using pkgs in index.nix imports → infinite recursion).
{ lib, pkgs, ... }: lib.mkIf pkgs.stdenv.isDarwin {
  home.packages = with pkgs; [ alt-tab-macos ];
}
