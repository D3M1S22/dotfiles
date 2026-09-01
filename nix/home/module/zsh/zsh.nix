{ config, dotfiles, ...}: {
  ## loading zsh config
 programs.zsh = {
    enable = true;
    initContent = ''
      source ${dotfiles}/zsh/.zshrc
    '';
  };
}