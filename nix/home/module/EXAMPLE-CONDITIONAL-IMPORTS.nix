# Example: conditional imports and options by system (Darwin vs Linux)
#
# Use this file as a reference. You can copy patterns into module/index.nix
# or into individual modules.
#
# Patterns:
#   1. Conditional imports in index.nix (recommended): only load a module on one OS.
#   2. Conditional options inside a module: enable options only when condition holds.
#   3. Full conditional module: wrap the whole module in lib.mkIf so it only applies on one OS.
# --------------------------------------------------------------------------------

# --- Pattern 1: Conditional imports (use in home/module/index.nix) ---
#
# In index.nix you have access to { lib, pkgs, ... }. Use:
#
#   imports = [
#     ./zsh/zsh.nix
#     ./ghostty/ghostty.nix
#     # ... shared modules ...
#   ]
#   ++ lib.optionals pkgs.stdenv.isDarwin [
#     ./alttab/alttab.nix
#     ./orbstack/orbstack.nix
#   ]
#   ++ lib.optionals pkgs.stdenv.isLinux [
#     ./some-linux-only/some-linux-only.nix
#   ];
#
# So: shared list ++ darwin-only list ++ linux-only list.

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
