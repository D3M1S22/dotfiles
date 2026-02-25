{ pkgs, inputs, lib, ... }: {
  
  imports = [ inputs.zen-browser.homeModules.twilight ];

  programs.zen-browser = {
    enable = true;
    policies = {
      DisableAppUpdate = true;
      DisableTelemetry = true;
    };
  };

  home.packages = [ pkgs.nixgl.auto.nixGLDefault ];

  xdg.desktopEntries."zen-twilight" = {
    name = "Zen Twilight";
    genericName = "Web Browser";
    # No crazy wrappers, just nixGL + Zen!
    exec = "${pkgs.nixgl.auto.nixGLDefault}/bin/nixGL ${inputs.zen-browser.packages."${pkgs.system}".twilight}/bin/zen %u";
    icon = "zen-twilight";
    terminal = false;
    categories = [ "Network" "WebBrowser" ];
    mimeType = [ "text/html" "text/xml" "application/xhtml+xml" "x-scheme-handler/http" "x-scheme-handler/https" ];
  };
}
