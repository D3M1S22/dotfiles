#!/usr/bin/env bash

# Base directory setup ensures this works from any working directory
BASE_DIR="$HOME/dotfiles"
FILE="$BASE_DIR/nix/home/module/index.nix"
COMMAND=$1


verify_package() {
  echo "🔍 Verifying '$MODULE'..."

  # 1. Fast Path: Exact check via Nix evaluation
  if nix eval "nixpkgs#$MODULE.name" >/dev/null 2>&1; then
    echo "✅ Package '$MODULE' found in nixpkgs!"
    return 0
  fi

  echo -e "⚠️  Warning: Exact package '$MODULE' not found."
  echo "🔍 Querying NixOS search API for alternatives..."

  # 2. Query the official NixOS search API (instant and accurate)
  local api_url="https://search.nixos.org/backend/es-0001/_search"
  local query_payload='{
    "size": 5,
    "query": {
      "match": {
        "package_pname": "'"$MODULE"'"
      }
    }
  }'

  # Fetch suggestions using curl and parse names using grep/sed (or jq if available)
  local raw_results
  raw_results=$(curl -s -X POST "$api_url" -H "Content-Type: application/json" -d "$query_payload" 2>/dev/null)

  # Extract package names from the JSON response safely without heavy dependencies
  local suggestions=()
  while IFS= read -r line; do
    [[ -n "$line" ]] && suggestions+=("$line")
  done < <(echo "$raw_results" | grep -o '"package_pname":"[^"]*"' | cut -d'"' -f4 | head -n 5)

  # If no suggestions found via API, fallback to custom prompt
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

  for ((i=0; i<num_options; i++)); do echo ""; done
  echo -en "\033[${num_options}A"

  while true; do
    for i in "${!options[@]}"; do
      if [ $i -eq $selected ]; then
        echo -e "  > \033[1;36m${options[$i]}\033[0m\033[K"
      else
        echo -e "    ${options[$i]}\033[K"
      fi
    done

    read -rsn1 key
    if [[ $key == $'\e' ]]; then
      read -rsn2 -t 0.1 key2
      if [[ $key2 == "[A" ]]; then
        ((selected--))
        if [ $selected -lt 0 ]; then selected=$((num_options - 1)); fi
      elif [[ $key2 == "[B" ]]; then
        ((selected++))
        if [ $selected -ge $num_options ]; then selected=0; fi
      fi
    elif [[ $key == "" ]]; then
      break
    endif

    echo -en "\033[${num_options}A"
  done

  if [ $selected -eq $((num_options - 1)) ]; then
    echo "❌ Aborted module creation."
    exit 1
  elif [ $selected -eq $((num_options - 2)) ]; then
    echo "✅ Proceeding with custom name: '$MODULE'"
  else
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