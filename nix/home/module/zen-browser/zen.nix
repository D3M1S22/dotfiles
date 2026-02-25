{ pkgs, inputs, lib, ... }: {

  # Import the Home Manager module from the flake
  imports = [ inputs.zen-browser.homeModules.twilight ];

  programs.zen-browser = {
    enable = true;

    # Now you can use the cool features from the docs!
    policies = {
      DisableAppUpdate = true;
      DisableTelemetry = true;
      # more and more
    };
  };

  home.packages = [ pkgs.nixgl.auto.nixGLDefault ];

  # 2. Create a custom launcher that wraps Zen with nixGL.
  #    This overrides the default icon in your app launcher.
  # We name this "zen-twilight" to override the default broken one
  xdg.desktopEntries."zen-twilight" = {
    name = "Zen Twilight";
    genericName = "Web Browser";
    # Point to the TWILIGHT binary wrapped in nixGL
    exec = "${pkgs.nixgl.auto.nixGLDefault}/bin/nixGL ${inputs.zen-browser.packages."${pkgs.system}".twilight}/bin/zen-twilight %u";
    icon = "zen-twilight";
    terminal = false;
    categories = [ "Network" "WebBrowser" ];
    mimeType = [ "text/html" "text/xml" "application/xhtml+xml" "x-scheme-handler/http" "x-scheme-handler/https" ];
  };
}