# ✨ dotfiles — home sweet config ✨

> hi! this README lists the dotfiles i use (and plan to use).  
> quick redirect to the nix README: <a href="./nix/README.md">Go to nix/README.md →</a>  
> (also trying an HTML redirect — if your viewer supports it, you'll be taken there)
<meta http-equiv="refresh" content="0; url=./nix/README.md">

---

## 💖 What this repo is
A tiny, cozy place for all my machine configuration — shells, editors, terminal, git, and more. Use this as the single source of truth, symlink manager target, or chezmoi/home-manager source.

## 🗂️ Current dotfiles
(Replace or check as needed)
- .bashrc / .zshrc — shell goodies
- .profile / .pam_environment
- .gitconfig
- .gitignore_global
- .tmux.conf
- .p10k.zsh / .oh-my-zsh configs
- .config/nvim/init.vim (or init.lua)
- .config/nvim/lua/...
- .config/alacritty/alacritty.yml
- .config/kitty/kitty.conf
- .config/wezterm/wezterm.lua
- .ssh/config
- .ideavimrc
- .config/starship.toml
- scripts/ (helper scripts & bin)

## 🌱 Planned / TODO
- home-manager modules for user packages
- full nix flake + system flake integration
- dotfiles for macOS-specific settings
- dotfiles for work laptop (separate profile)
- automated install script / onboarding README

## 🛠️ How to use
- Symlink approach (example with stow):
    - stow -v -t $HOME nvim git zsh tmux
- chezmoi:
    - chezmoi init <repo>
    - chezmoi apply
- nix / home-manager:
    - see ./nix/README.md (primary entrypoint)

## 🔧 Tips
- Keep secrets out: use a secrets/ or .git-crypt gpg store, or reference secrets from nix’s secrets handling.
- Test changes in a safe environment (VM / container / separate user) before applying system-wide.

## 🐣 Contributing
Small tweaks welcome. Open a PR with a short description and a screenshot (if UI change). Keep the vibe cute.

## 📜 License
Default to your preferred license (e.g., MIT). Add LICENSE file.

---

Thanks for stopping by — may your configs be tidy and your shells fast! ✨