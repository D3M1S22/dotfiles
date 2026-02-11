{ config, dotfiles, ...}: {
  ## loading zsh config
 programs.zsh = {
    enable = true;
    initExtra = ''
      source ${dotfiles}/zsh/.zshrc
    '';
  };
}