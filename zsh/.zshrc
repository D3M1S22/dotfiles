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

reboot-win() {
    # Find the boot number for Windows
    WIN_BOOTNUM=$(efibootmgr | grep -i "Windows Boot Manager" | grep -oP 'Boot\K[0-9A-Fa-f]{4}')

    # Check if we actually found a number
    if [ -n "$WIN_BOOTNUM" ]; then
        echo "Found Windows at Boot$WIN_BOOTNUM. Rebooting..."
        sudo efibootmgr -n "$WIN_BOOTNUM" && reboot
    else
        echo "Error: Could not find 'Windows Boot Manager' in UEFI entries."
    fi
}
