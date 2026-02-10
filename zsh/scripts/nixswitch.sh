#!/usr/bin/env bash
# Apply Nix config for the current system automatically.
# Uses builtins.currentSystem to choose darwin vs home-manager and config name.
set -e
FLAKE="${NIX_FLAKE_PATH:-$HOME/dotfiles/nix}"

export NIX_CONFIG="experimental-features = nix-command flakes"
current_system=$(nix eval --impure --raw --expr 'builtins.currentSystem')
case "$current_system" in
  aarch64-darwin)  config="home-air" ;;
  x86_64-darwin)   config="home-air" ;;  # or home-air-intel if you add it
  x86_64-linux)   config="home-linux" ;;
  aarch64-linux)  config="home-linux" ;;  # or home-linux-aarch64 if you add it
  *)
    echo "Unsupported system: $current_system" >&2
    exit 1
    ;;
esac

if [[ "$current_system" == *"-darwin" ]]; then
  echo "Darwin detected ($current_system) -> darwin-rebuild --flake $FLAKE#$config"
  exec sudo darwin-rebuild switch --flake "$FLAKE#$config"
else
  echo "Linux detected ($current_system) -> home-manager --flake $FLAKE#$config -b preHM"
  exec home-manager switch --flake "$FLAKE#$config" -b preHM
fi
