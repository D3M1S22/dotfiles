#!/bin/bash

nixupdate() {
  local choice="${1:-}"
  # 1. Full list of inputs (including new ones)
  local inputs=(nixpkgs dotfiles home-manager nixgl zen-browser nvf)
  
  # 2. Smart Detection: Use sudo only on macOS
  local nix_cmd="nix"
  if [[ "$(uname)" == "Darwin" ]]; then
    nix_cmd="sudo nix"
  fi

  if [ -z "$choice" ]; then
    PS3="Choose what do you want to update (number): "
    select choice in "${inputs[@]}" all Exit; do
      [[ -n "$choice" ]] && break
      echo "Not a valid choice, retry"
    done 
  fi

  [[ "$choice" == "Exit" || -z "$choice" ]] && return 0
  echo "Updating '$choice' on system: $(uname)"
  echo "Using command: $nix_cmd flake lock ..."

  (
    cd ~/dotfiles/nix &&
    if [[ "$choice" == "tutto" || "$choice" == "all" ]]; then
      # Update everything
      $nix_cmd flake lock $(printf ' --update-input %s' "${inputs[@]}")
    else
      # Update single input
      $nix_cmd flake lock --update-input "$choice"
    fi
  )
}

nixupdate $1
