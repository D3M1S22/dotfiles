# nix (dotfiles)

Minimal README for managing this repository with nix-darwin and home-manager (flake-based).

## Requirements
- Nix with flakes enabled
- nix-darwin installed (for macOS)
- home-manager (included via flake)

## Quick commands

Replace `<host>` or `<user>` with your flake output names (e.g. `macbook` or your username).

- Apply darwin configuration (rebuild + switch):
    ```
    darwin-rebuild switch --flake .#<host>
    ```
- Build darwin artifacts (without switching):
    ```
    darwin-rebuild build --flake .#<host>
    ```
- Test configuration (dry-run):
    ```
    darwin-rebuild test --flake .#<host>
    ```
- Apply home-manager config (if exposed separately):
    ```
    home-manager switch --flake .#<user>
    ```

- Update flakes:
    ```
    nix flake update
    ```
- Inspect flake outputs:
    ```
    nix flake show
    ```
- Build a specific output:
    ```
    nix build .#darwinConfigurations.<host>.system
    ```
- Enter a dev shell:
    ```
    nix develop
    ```

- Cleanup old generations / GC:
    ```
    sudo nix-collect-garbage -d
    ```

## Tips
- Use `hostname` to get the current machine name for flake targets:
    ```
    darwin-rebuild switch --flake .#$(hostname)
    ```
- Keep changes small and test with `darwin-rebuild build` or `test` before `switch`.
- Use `nix flake show` to discover available outputs (hostnames, modules, apps).

## Troubleshooting
- If a rebuild fails, inspect `/var/log/system.log` and `~/.cache/nix` for build logs.
- Run `nix flake update` then rebuild if dependencies changed.
- For permission issues with GC, use `sudo` for `nix-collect-garbage`.

Feel free to adapt hosts and usernames to this repo's flake outputs.