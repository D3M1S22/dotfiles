#!/usr/bin/env bash

# Base directory setup ensures this works from any working directory
BASE_DIR="$HOME/dotfiles"
FILE="$BASE_DIR/nix/home/module/index.nix"
COMMAND=$1


verify_package() {
  echo "🔍 Verifying '$MODULE'..."

  # 1. The Fast Path: Instant exact match evaluation
  if nix eval "nixpkgs#$MODULE.name" >/dev/null 2>&1; then
    echo "✅ Package '$MODULE' found in nixpkgs!"
    return 0
  fi

  # 2. The Fallback Path: Search for alternatives
  echo -e "⚠️  Warning: Exact package '$MODULE' not found."
  echo "🔍 Searching for similar packages..."

  # Fetch the top 5 suggestions into a bash array
  local suggestions=($(nix search nixpkgs "$MODULE" 2>/dev/null | grep "^\* " | head -n 5 | awk '{print $2}' | sed 's/.*#//'))

  # If no suggestions exist, fallback to a simple Y/N prompt
  if [ ${#suggestions[@]} -eq 0 ]; then
    echo "  (No similar packages found)"
    read -p "Do you want to create the custom module '$MODULE' anyway? [y/N]: " confirm
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
      echo "❌ Aborted module creation."
      exit 1
    fi
    return 0
  fi

  # Build the interactive menu options
  local options=("${suggestions[@]}" "Continue with custom name: '$MODULE'" "Abort")
  local num_options=${#options[@]}
  local selected=0

  echo -e "\nDid you mean one of these? (Use Arrow Keys & Enter)\n"

  # Print initial empty lines to make space for the menu
  for ((i=0; i<num_options; i++)); do echo ""; done
  
  # Move the cursor back up to the start of the menu
  echo -en "\033[${num_options}A"

  # Interactive Loop
  while true; do
    for i in "${!options[@]}"; do
      if [ $i -eq $selected ]; then
        # Highlight selected option in Cyan
        echo -e "  > \033[1;36m${options[$i]}\033[0m\033[K"
      else
        echo -e "    ${options[$i]}\033[K"
      fi
    done

    # Read a single keystroke
    read -rsn1 key
    if [[ $key == $'\e' ]]; then
      # Read the rest of the arrow key escape sequence
      read -rsn2 -t 0.1 key2
      if [[ $key2 == "[A" ]]; then # Up Arrow
        ((selected--))
        if [ $selected -lt 0 ]; then selected=$((num_options - 1)); fi
      elif [[ $key2 == "[B" ]]; then # Down Arrow
        ((selected++))
        if [ $selected -ge $num_options ]; then selected=0; fi
      fi
    elif [[ $key == "" ]]; then # Enter Key
      break
    fi

    # Move the cursor back up to redraw the menu cleanly
    echo -en "\033[${num_options}A"
  done

  # Process the user's selection
  if [ $selected -eq $((num_options - 1)) ]; then
    echo "❌ Aborted module creation."
    exit 1
  elif [ $selected -eq $((num_options - 2)) ]; then
    echo "✅ Proceeding with custom name: '$MODULE'"
  else
    # Updates the global MODULE variable so the rest of the script uses the correct name
    MODULE="${options[$selected]}"
    echo "✅ Selected package: '$MODULE'"
  fi
}

if [ ! -f "$FILE" ]; then
  echo "Error: Cannot find $FILE."
  exit 1
fi

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

    verify_package

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