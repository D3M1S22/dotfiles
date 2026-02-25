{ pkgs, inputs, lib, ... }:

let
  # A robust wrapper script that bypasses .desktop validation errors
  # and ensures Wayland variables are always present even if Walker drops them.
  zen-wrapper = pkgs.writeShellScriptBin "zen-nixgl-wrapper" ''
    #!/usr/bin/env bash
    
    # If Walker/UWSM loses the display variables, fetch them directly from systemd
    if [ -z "$WAYLAND_DISPLAY" ]; then
      export WAYLAND_DISPLAY=$(systemctl --user show-environment | grep '^WAYLAND_DISPLAY=' | cut -d= -f2)
    fi
    if [ -z "$DISPLAY" ]; then
      export DISPLAY=$(systemctl --user show-environment | grep '^DISPLAY=' | cut -d= -f2)
    fi

    # Launch Zen with nixGL and pass any arguments (like URLs) using "$@"
    exec ${pkgs.nixgl.auto.nixGLDefault}/bin/nixGL ${inputs.zen-browser.packages."${pkgs.system}".twilight}/bin/zen "$@"
  '';
in
{
  imports = [ inputs.zen-browser.homeModules.twilight ];

  programs.zen-browser = {
    enable = true;
    policies = {
      DisableAppUpdate = true;
      DisableTelemetry = true;
    };
  };

  home.packages = [
    pkgs.nixgl.auto.nixGLDefault
    zen-wrapper
  ];

  xdg.desktopEntries."zen-twilight" = {
    name = "Zen Twilight";
    genericName = "Web Browser";
    
    # Point directly to our clean wrapper script
    exec = "${zen-wrapper}/bin/zen-nixgl-wrapper %u";
    
    icon = "zen-twilight";
    terminal = false;
    categories = [ "Network" "WebBrowser" ];
    mimeType = [ "text/html" "text/xml" "application/xhtml+xml" "x-scheme-handler/http" "x-scheme-handler/https" ];
  };
}
