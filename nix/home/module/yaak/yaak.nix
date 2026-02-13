{ pkgs, ... }:
{
  home.packages = with pkgs; [
    yaak  
  ] ++ lib.optionals pkgs.stdenv.isLinux [
    nixgl.auto.nixGLDefault
  ];

  xdg.desktopEntries.yaak = lib.mkIf pkgs.stdenv.isLinux {
    name = "Yaak";
    genericName = "API Client";
    exec = "${pkgs.nixgl.auto.nixGLDefault}/bin/nixGL ${pkgs.yaak}/bin/yaak %U";
    icon = "yaak";
    terminal = false;
    categories = [ "Development" "Utility" ];
  };
}
