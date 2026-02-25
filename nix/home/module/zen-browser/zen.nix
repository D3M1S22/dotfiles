{ pkgs, inputs, lib, ... }:

let
  zen-wrapper = pkgs.writeShellScriptBin "zen-nixgl-wrapper" ''
    #!/usr/bin/env bash
    
    # 1. Force EVERYTHING (output and errors) to be written to a log file
    exec > /tmp/zen-debug.log 2>&1
    set -x

    echo "--- LAUNCHING ZEN VIA WALKER/UWSM ---"
    echo "Current Date: $(date)"
    echo "Initial WAYLAND_DISPLAY: $WAYLAND_DISPLAY"
    echo "Initial DISPLAY: $DISPLAY"
    echo "Initial XDG_RUNTIME_DIR: $XDG_RUNTIME_DIR"

    export PATH="/run/current-system/sw/bin:/usr/bin:/bin:$PATH"

    # Attempt Wayland recovery
    if [ -z "$WAYLAND_DISPLAY" ]; then
      echo "WAYLAND_DISPLAY was missing. Hunting for socket..."
      for s in /run/user/$(id -u)/wayland-*; do
        if [ -S "$s" ]; then
          export WAYLAND_DISPLAY=$(basename "$s")
          echo "Found Wayland socket: $WAYLAND_DISPLAY"
          break
        fi
      done
    fi

    # Attempt X11 recovery
    if [ -z "$DISPLAY" ]; then
      export DISPLAY=":0"
      echo "Set default DISPLAY: $DISPLAY"
    fi

    echo "--- ENVIRONMENT READY ---"
    echo "Executing nixGL Zen..."
    
    # Run the browser
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
    exec = "${zen-wrapper}/bin/zen-nixgl-wrapper %u";
    icon = "zen-twilight";
    terminal = false;
    categories = [ "Network" "WebBrowser" ];
    mimeType = [ "text/html" "text/xml" "application/xhtml+xml" "x-scheme-handler/http" "x-scheme-handler/https" ];
  };
}