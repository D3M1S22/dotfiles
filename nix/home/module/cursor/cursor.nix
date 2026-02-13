{ pkgs, ... }: {
  
  home.packages = with pkgs; [
    code-cursor 
  ] ++ lib.optionals pkgs.stdenv.isLinux [
    nixgl.auto.nixGLDefault
  ]; 

  # Create a custom desktop entry that wraps the command
  xdg.desktopEntries.cursor = lib.mkIf pkgs.stdenv.isLinux {
    name = "Cursor";
    genericName = "Text Editor";
    exec = "${pkgs.nixgl.auto.nixGLDefault}/bin/nixGL ${pkgs.code-cursor}/bin/cursor %F";
    icon = "cursor";
    terminal = false;
    categories = [ "Utility" "TextEditor" "Development" "IDE" ];
    mimeType = [ "text/plain" "inode/directory" ];
  };
}
