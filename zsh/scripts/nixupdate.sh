#!/bin/bash

nixupdate() {
  local choice="${1:-}"
  local inputs=(nixpkgs dotfiles)
  if [ -z "$choice" ]; then
    PS3="Choose what do you want to update (number): "
    select choice in "${inputs[@]}" all Exit; do
      [[ -n "$choice" ]] && break
      echo "Not a valid choice, retry"
    done 
  fi

  [[ "$choice" == "Exit" || -z "$choice" ]] && return 0
  echo "$choice"
    # one nix command; "tutto" updates all inputs
  (
    cd ~/dotfiles/nix &&
    if [[ "$choice" == "tutto" || "$choice" == "all" ]]; then
      sudo nix flake lock $(printf ' --update-input %s' "${inputs[@]}")
    else
      sudo nix flake lock --update-input "$choice"
    fi
  )
}

nixupdate $1
