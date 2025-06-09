# 🛠️ Dotfiles

This repository contains my personal dotfiles and a `bootstrap.sh` installer to automate the configuration of:

- 🐚 Zsh 
- 🧠 Neovim
- 🪟 Tmux
- 🎨 Dracula GNOME Terminal Theme
- 🔤 JetBrainsMono Nerd Font
- 🔗 Symlinks managed via `stow`
- 🧰 Third-party dependencies cloned into `repos/`

---

## 📦 Installation

Run the following on any Ubuntu-based system:
```bash
git clone https://github.com/baj31415/dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod a+x bootstrap.sh
./bootstrap.sh

