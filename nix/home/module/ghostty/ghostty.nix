# Ghostty: base config from dotfiles + optional OS-specific files.
# Ghostty docs: config-file=?path loads path only if it exists (platform-specific).
{ config, dotfiles, lib, pkgs, ... }: {
  home.packages = with pkgs; [ ghostty-bin ];

  # Use a real dir (per-file) so we can add OS-only files; whole-dir source would symlink and prevent that.
  xdg.configFile."ghostty/config".source = "${dotfiles}/ghostty/config";
  xdg.configFile."ghostty/style".source = "${dotfiles}/ghostty/style";
  xdg.configFile."ghostty/keybinds".source = "${dotfiles}/ghostty/keybinds";

  # OS-specific: only one of these exists per machine; Ghostty loads it via config-file=?macos.conf / ?linux.conf
  xdg.configFile."ghostty/macos.conf" = lib.mkIf pkgs.stdenv.isDarwin {
    text = ''
      # macOS-only options (loaded only when this file exists)
      macos-icon = retro
    '';
  };
  xdg.configFile."ghostty/linux.conf" = lib.mkIf pkgs.stdenv.isLinux {
    text = ''
      # Linux-only options (loaded only when this file exists)
      # e.g. wayland-title = 0
    '';
  };
}