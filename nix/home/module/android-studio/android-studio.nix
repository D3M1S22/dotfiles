{ pkgs, lib, ... }: {
  
  home.packages = with pkgs; [
    android-studio
  ] ++ lib.optionals pkgs.stdenv.isLinux [
    nixgl.auto.nixGLDefault
  ];

  # Create a custom desktop entry that wraps the clean command in nixGL
  xdg.desktopEntries."android-studio" = lib.mkIf pkgs.stdenv.isLinux {
    name = "Android Studio";
    genericName = "Integrated Development Environment";
    exec = "${pkgs.nixgl.auto.nixGLDefault}/bin/nixGL ${pkgs.android-studio}/bin/android-studio %f";
    icon = "android-studio";
    terminal = false;
    categories = [ "Development" "IDE" ];
    startupWMClass = "jetbrains-studio"; # Helps Wayland group the window correctly
  };
}
