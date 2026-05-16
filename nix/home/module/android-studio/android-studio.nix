{ pkgs, lib, ... }: {
  
  home.packages = with pkgs; [
    android-studio
  ] ++ lib.optionals pkgs.stdenv.isLinux [
    nixgl.auto.nixGLDefault
  ];

  xdg.desktopEntries."android-studio" = lib.mkIf pkgs.stdenv.isLinux {
    name = "Android Studio";
    genericName = "Integrated Development Environment";
    exec = "${pkgs.nixgl.auto.nixGLDefault}/bin/nixGL ${pkgs.android-studio}/bin/android-studio %f";
    icon = "android-studio";
    terminal = false;
    categories = [ "Development" "IDE" ];
    
    # Custom .desktop properties go in the settings block!
    settings = {
      StartupWMClass = "jetbrains-studio";
    };
  };
}
