{ pkgs, ...}:
{
  home.packages = with pkgs; [
    alt-tab-macos # use alttab for linux
  ];
}
