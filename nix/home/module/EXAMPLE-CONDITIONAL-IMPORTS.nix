# Example: conditional imports and options by system (Darwin vs Linux)
#
# Use this file as a reference. You can copy patterns into module/index.nix
# or into individual modules.
#
# Patterns:
#   1. Conditional imports in index.nix – AVOID with pkgs (causes infinite recursion under nix-darwin).
#   2. Conditional options inside a module: enable options only when condition holds.
#   3. Full conditional module (recommended for OS-only): wrap the whole module in lib.mkIf.
# --------------------------------------------------------------------------------

# --- Pattern 1: Conditional imports – AVOID in this repo ---
#
# Using pkgs.stdenv.isDarwin in index.nix imports causes "infinite recursion" when
# building with nix-darwin (pkgs is resolved from config, which depends on imports).
# Prefer Pattern 3: import the module always and use lib.mkIf inside the module.

# --- Pattern 2: Conditional options inside a single module ---
#
# If a module should exist on both OSes but some options are OS-specific:
#
# { config, lib, pkgs, ... }:
# {
#   home.packages = with pkgs; [
#     git
#   ]
#   ++ lib.optionals pkgs.stdenv.isDarwin [ orbstack ]
#   ++ lib.optionals pkgs.stdenv.isLinux [ podman ];
#
#   # Or use lib.mkIf for a whole block:
#   programs.alacritty.settings = lib.mkIf pkgs.stdenv.isDarwin {
#     window.decorations = "full";
#   };
# }

# --- Pattern 3: Whole module only on one OS ---
#
# Make the entire module a no-op on the other OS (cleaner than conditional imports
# when the file is only for one OS):
#
# { config, lib, pkgs, ... }:
# lib.mkIf pkgs.stdenv.isDarwin {
#   home.packages = with pkgs; [ alt-tab-macos ];
# }
#
# Use this inside a module that is always imported; then you don't need to
# remove it from imports on Linux.

# --- Summary ---
# - Prefer Pattern 1 in index.nix for clear "this module is Darwin-only".
# - Use Pattern 2 when one module has both shared and OS-specific options.
# - Use Pattern 3 when the whole file is for one OS and you want to keep it
#   in the imports list for clarity.
