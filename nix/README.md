# Nix config (dotfiles)

nix-darwin (macOS) + home-manager (shared), flake-based.

## Requirements

- **Nix with flakes** – On Linux, flakes are often not enabled by default. Either enable them once (see below) or the scripts set `NIX_CONFIG` so `nix run .#switch-linux` and `nixswitch` work without config changes.
- **macOS:** [nix-darwin](https://github.com/LnL7/nix-darwin) installed
- **Linux:** home-manager is provided by the flake (standalone, no NixOS required)

**Enable flakes on Linux (optional, persistent):** create or edit `~/.config/nix/nix.conf` and add:
```ini
experimental-features = nix-command flakes
```
(On NixOS, set `nix.settings.experimental-features` in your config instead.)

---

## How to run everything

Flake path used below: `~/dotfiles/nix` (or `$HOME/dotfiles/nix`). From the repo root you can use `./nix` or `nix` as the flake path.

### One command that picks OS for you

From your dotfiles (or set `NIX_FLAKE_PATH`):

```bash
nixswitch
```

- On **macOS** → runs `darwin-rebuild switch --flake <path>#home-air`
- On **Linux** → runs `home-manager switch --flake <path>#home-linux -b preHM`

Defined in `zsh/scripts/nixswitch.sh`; alias in `zsh/.zshrc`.

---

### macOS (nix-darwin)

| Action | Command |
|--------|--------|
| **Switch** (apply system + home-manager) | `sudo darwin-rebuild switch --flake ~/dotfiles/nix#home-air` |
| Build only (no switch) | `darwin-rebuild build --flake ~/dotfiles/nix#home-air` |
| Dry-run | `darwin-rebuild test --flake ~/dotfiles/nix#home-air` |

Alias: `nixrebuild` = switch for `#home-air`.

---

### Linux (standalone home-manager)

| Action | Command |
|--------|--------|
| **Switch** (apply home-manager only) | `home-manager switch --flake ~/dotfiles/nix#home-linux -b preHM` |
| Build only | `home-manager build --flake ~/dotfiles/nix#home-linux` |

The `-b preHM` flag backs up existing files (e.g. `~/.config/ghostty` → `~/.config/ghostty.preHM`) before linking. `nixswitch` includes it automatically. Use the same config name you added in the flake (`linuxHosts`), e.g. `#home-linux` or `#home-linux-aarch64`.

---

### Updating the flake

```bash
cd ~/dotfiles/nix
nix flake lock --update-input nixpkgs   # update one input
nix flake lock --update-input nixpkgs --update-input home-manager  # several
nix flake update                         # update all inputs
```

Script (from repo): `nixupdate` (or `sh ~/dotfiles/zsh/scripts/nixupdate.sh`) — updates chosen inputs then runs `nixrebuild` (Darwin). On Linux run `home-manager switch --flake ...` after updating if you want to apply.

---

### Inspecting the flake

```bash
cd ~/dotfiles/nix
nix flake show                    # list all outputs
nix flake show .#home-air         # darwin config
nix flake show .#home-linux       # home-manager config
```

---

### Cleanup

```bash
sudo nix-collect-garbage -d       # delete old generations and run GC
```

---

## Config names (flake outputs)

Defined in `flake.nix`:

- **Darwin:** `darwinHosts` → e.g. `home-air` (aarch64-darwin)
- **Linux:** `linuxHosts` → e.g. `home-linux` (x86_64-linux)

Add more hosts there (e.g. `home-air-intel`, `home-linux-aarch64`) and use the same commands with the new `#<name>`.

---

## Conditional modules (Darwin vs Linux)

Some home-manager modules are macOS-only (e.g. alttab, orbstack). They are gated in `home/module/index.nix` using `lib.optionals pkgs.stdenv.isDarwin [ ... ]`.

See **`home/module/EXAMPLE-CONDITIONAL-IMPORTS.nix`** for:

1. Conditional imports in `index.nix` (Darwin-only / Linux-only lists).
2. Conditional options inside a module (`lib.mkIf`, `lib.optionals`).
3. Making a whole module apply only on one OS (`lib.mkIf pkgs.stdenv.isDarwin { ... }`).

---

## Troubleshooting

- **Build fails:** Check `nix build .#darwinConfigurations.home-air.system` or `nix build .#homeConfigurations.home-linux` to see errors; run `nix flake update` if inputs changed.
- **Permission / GC:** Use `sudo` for `nix-collect-garbage` and for `darwin-rebuild switch`.
- **Linux:** Ensure home-manager is in PATH (e.g. `nix profile install` from the flake or install via your distro).
