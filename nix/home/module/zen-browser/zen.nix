{ pkgs, inputs, lib, ... }:

let
  # The "Armor" Wrapper: Immune to Omarchy stripping environment variables
  zen-wrapper = pkgs.writeShellScriptBin "zen-nixgl-wrapper" ''
    #!/usr/bin/env bash
    
    # 1. Force a basic PATH so standard commands work
    export PATH="/run/current-system/sw/bin:/usr/bin:/bin:$PATH"

    # 2. Find the Wayland display socket directly on the hard drive
    if [ -z "$WAYLAND_DISPLAY" ]; then
      for s in /run/user/$(id -u)/wayland-*; do
        if [ -S "$s" ]; then
          export WAYLAND_DISPLAY=$(basename "$s")
          break
        fi
      done
    fi

    # 3. Default X11 fallback just in case
    if [ -z "$DISPLAY" ]; then
      export DISPLAY=":0"
    fi

    # 4. Launch!
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
    
    # Use our armored wrapper
    exec = "${zen-wrapper}/bin/zen-nixgl-wrapper %u";
    
    icon = "zen-twilight";
    terminal = false;
    categories = [ "Network" "WebBrowser" ];
    mimeType = [ "text/html" "text/xml" "application/xhtml+xml" "x-scheme-handler/http" "x-scheme-handler/https" ];
  };
}
