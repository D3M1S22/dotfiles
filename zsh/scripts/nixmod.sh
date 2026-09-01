#!/usr/bin/env bash

# Base directory setup ensures this works from any working directory
BASE_DIR="$HOME/dotfiles"
FILE="$BASE_DIR/nix/home/module/index.nix"

if [ ! -f "$FILE" ]; then
  echo "Error: Cannot find $FILE."
  exit 1
fi

COMMAND=$1

case $COMMAND in
  add)
    TARGET=$2
    MODULE=$3

    if [ -z "$MODULE" ]; then
      echo "Error: 'add' requires a target (both|mac|linux) and a modulename."
      exit 1
    fi

    case $TARGET in
      mac) MARKER="# MAC_MODULES" ;;
      linux) MARKER="# LINUX_MODULES" ;;
      both) MARKER="# UNIVERSAL_MODULES" ;;
      *) echo "Invalid target. Use 'mac', 'linux', or 'both'."; exit 1 ;;
    esac

    # Paths updated to use absolute base directory and correct relative imports
    MODULE_DIR="$BASE_DIR/nix/home/module/$MODULE"
    MODULE_FILE="$MODULE_DIR/$MODULE.nix"
    IMPORT_PATH="./$MODULE/$MODULE.nix"

    # 1. Create directory and template file if they do not exist
    if [ ! -f "$MODULE_FILE" ]; then
      mkdir -p "$MODULE_DIR"
      cat <<EOF > "$MODULE_FILE"
{ config, pkgs, lib, ... }:

{
  # Configuration for $MODULE
  home.packages = with pkgs; [
    $MODULE
  ];
}
EOF
      echo "Created template at $MODULE_FILE"
    else
      echo "File $MODULE_FILE already exists."
    fi

    # 2. Append the import path and the tag on the line below the marker
    # The $ enforces end-of-line matching so "gh" won't match "ghostty"
    if ! grep -qE "#${MODULE}$" "$FILE"; then
      awk -v marker="$MARKER" -v mod="    $IMPORT_PATH #$MODULE" '
        $0 ~ marker {print; print mod; next} 1
      ' "$FILE" > tmp && mv tmp "$FILE"
      echo "Added $MODULE to $TARGET in $FILE."
    else
      echo "Module $MODULE is already imported in $FILE."
    fi

    # 3. Open the newly created file in Neovim
    ${EDITOR:-nvim} "$MODULE_FILE"
    ;;

  rm)
    MODULE=$2
    # Swapped index() for a regex match to enforce the end-of-line boundary
    awk -v tag="#${MODULE}$" '$0 !~ tag' "$FILE" > tmp && mv tmp "$FILE"
    echo "Removed $MODULE from imports."
    ;;

  comment)
    MODULE=$2
    awk -v tag="#${MODULE}$" '$0 ~ tag && $0 !~ /^[ \t]*#/ { sub(/^[ \t]*/, "&# ") } 1' "$FILE" > tmp && mv tmp "$FILE"
    echo "Commented out $MODULE."
    ;;

  uncomment)
    MODULE=$2
    awk -v tag="#${MODULE}$" '$0 ~ tag && $0 ~ /^[ \t]*#/ { sub(/#[ \t]*/, "") } 1' "$FILE" > tmp && mv tmp "$FILE"
    echo "Uncommented $MODULE."
    ;;

  *)
    echo "Usage:"
    echo "  $0 add [both|mac|linux] <modulename>"
    echo "  $0 rm <modulename>"
    echo "  $0 comment <modulename>"
    echo "  $0 uncomment <modulename>"
    exit 1
    ;;
esac