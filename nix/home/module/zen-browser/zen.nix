{ pkgs, inputs, ... }: {

  # Import the Home Manager module from the flake
  imports = [ inputs.zen-browser.homeManagerModules.default ];

  programs.zen-browser = {
    enable = true;
    
    # 🚀 THE FIX: We wrap the flake's package with nixGL here!
    package = pkgs.writeShellScriptBin "zen" ''
      exec ${pkgs.nixgl.auto.nixGLDefault}/bin/nixGL ${inputs.zen-browser.packages."${pkgs.system}".default}/bin/zen "$@"
    '';

    # Now you can use the cool features from the docs!
    policies = {
      DisableAppUpdate = true;
      DisableTelemetry = true;
      # more and more
    };
  };
}