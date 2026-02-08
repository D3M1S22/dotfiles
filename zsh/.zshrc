local here="${${(%):-%N}:A:h}"
##### zshrc inclusion #####
#
  alias zshrcsrc="source ~/.zshrc"
  if command -v nvim >/dev/null 2>&1; then
    alias zshrc="nvim $here/.zshrc"
  else
    alias zshrc="vi $here/.zshrc"
  fi
  
# Rebuild nix conf (darwin-only). Use nixswitch for auto darwin/linux.
  alias nixrebuild="sudo darwin-rebuild switch --flake ~/dotfiles/nix#home-air"
  alias nixswitch="sh $HOME/dotfiles/zsh/scripts/nixswitch.sh"
#
###########################

##### nix #####
#
  [ -f $here/nix/.nixaliases ] && source $here/nix/.nixaliases
#
###############

##### ghostty #####
#
  [ -f $here/ghostty/.ghosttyaliases ] && source $here/ghostty/.ghosttyaliases
#
###################

##### starship #####
#
  eval "$(starship init zsh)"
#
####################

##### direnv #####
#
  eval "$(direnv hook zsh)"
#
#################