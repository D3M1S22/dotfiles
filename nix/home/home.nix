{ config, pkgs, lib, dotfiles, ... }: {
  home.username = "demis";
  home.homeDirectory = lib.mkForce "/Users/demis";
  # ✅ must be absolute path

  # imports = [ nvf.homeManagerModules.default ];

  home.packages = with pkgs; [
    alt-tab-macos
    starship
    ghostty-bin
    # alttab
    neovim
  ];

  
  ## loading zsh config
  home.file.".zshrc".source   = "${dotfiles}/zsh/.zshrc";
  ## loading ghostty config
   xdg.configFile."ghostty" = {
    source = "${dotfiles}/ghostty";
    # optional: make a real dir with per-file symlinks
    # recursive = true;
  };
  
  ## loading starship config
  xdg.configFile."starship.toml".source = "${dotfiles}/starship/starship.toml";

  ## loading nvim config
  xdg.configFile."nvim" = {
    source = "${dotfiles}/nvim";
    recursive = true;                          # <— makes a real ~/.config/nvim dir
    force = true;                              # <— replace old symlink if present
  };

  home.activation.masonInstallAll =
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if command -v ${pkgs.neovim}/bin/nvim >/dev/null; then
        ${pkgs.neovim}/bin/nvim --headless "+MasonInstallAll" +qa || true
      fi
    '';

  home.stateVersion = "25.11";
  
  programs.starship = {
    enable = true;
  };

}
