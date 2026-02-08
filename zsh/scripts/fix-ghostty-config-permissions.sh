#!/usr/bin/env bash
# Fix ownership of ~/.config/ghostty so home-manager can manage it (move/backup/link).
# Run once if you get "Permission denied" during home-manager activation.
set -e
DIR="${HOME}/.config/ghostty"
if [[ ! -d "$DIR" ]]; then
  echo "No $DIR directory, nothing to fix."
  exit 0
fi
# Take ownership of the directory and everything in it
sudo chown -R "$(whoami)" "$DIR"
echo "Ownership of $DIR set to $(whoami). You can run nixrebuild again."
chmod -R u+rwX "$DIR"
