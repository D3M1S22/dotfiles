{ pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    yaak  
  ] ++ lib.optionals pkgs.stdenv.isLinux [
    nixgl.auto.nixGLDefault
  ];

  xdg.desktopEntries.yaak = lib.mkIf pkgs.stdenv.isLinux {
    name = "Yaak";
    genericName = "API Client";
    exec = "${pkgs.nixgl.auto.nixGLDefault}/bin/nixGL ${pkgs.yaak}/bin/yaak-app %U";
    icon = "${pkgs.yaak}/share/icons/hicolor/128x128/apps/yaak-app.png";
    terminal = false;
    categories = [ "Development" "Utility" ];
  };
}
