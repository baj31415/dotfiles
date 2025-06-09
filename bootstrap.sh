#!/bin/bash
set -e

echo "🚀 Starting dotfiles setup..."

# ------------------------------------
# STEP 1: Install required packages
# ------------------------------------
echo "🔧 Installing packages with apt..."
sudo apt update
sudo apt install -y \
  git curl unzip \
  zsh tmux stow neovim \
  ripgrep fd-find build-essential \
  dconf-cli gnome-terminal

# ------------------------------------
# STEP 2: Install Oh My Zsh
# ------------------------------------
echo "🐚 Installing Oh My Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  RUNZSH=no KEEP_ZSHRC=yes \
  bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  echo "✅ Oh My Zsh already installed."
fi

# ------------------------------------
# STEP 3: Install Oh My Zsh Plugins
# ------------------------------------
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

echo "🔌 Installing zsh-autosuggestions..."
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

echo "🔌 Installing zsh-syntax-highlighting..."
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

# ------------------------------------
# STEP 4: Install JetBrainsMono Nerd Font
# ------------------------------------
echo "🔤 Installing JetBrainsMono Nerd Font..."
(
  FONT_DIR="$HOME/.local/share/fonts"
  mkdir -p "$FONT_DIR"
  cd "$FONT_DIR"
  if [ ! -f "JetBrainsMonoNerdFont-Regular.ttf" ]; then
    curl -LO https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
    unzip -o JetBrainsMono.zip
    rm JetBrainsMono.zip
    fc-cache -fv
    echo "✅ Nerd Font installed."
  else
    echo "✅ Nerd Font already installed."
  fi
)

# ------------------------------------
# STEP 5: Clone LazyVim into dotfiles
# ------------------------------------
DOTFILES_DIR="$(cd "$(dirname "$0")"; pwd)"
LOCAL_NVIM_DIR="$DOTFILES_DIR/nvim/.config/nvim"

if [ ! -d "$LOCAL_NVIM_DIR" ]; then
  echo "✨ Cloning LazyVim into dotfiles..."
  git clone https://github.com/LazyVim/starter "$LOCAL_NVIM_DIR"
  rm -rf "$LOCAL_NVIM_DIR/.git"
  echo "✅ LazyVim installed inside dotfiles."
else
  echo "✅ LazyVim already present in dotfiles."
fi

# ------------------------------------
# STEP 6: Remove conflicting dotfiles
# ------------------------------------
echo "🧹 Cleaning up conflicts..."
rm -f "$HOME/.zshrc"
rm -f "$HOME/.tmux.conf"
rm -rf "$HOME/.config/nvim"

# ------------------------------------
# STEP 7: Symlink dotfiles using Stow
# ------------------------------------
echo "🔗 Creating symlinks with stow..."
cd "$DOTFILES_DIR"
stow zsh
stow tmux
stow nvim

# ------------------------------------
# STEP 8: Set Zsh as default shell
# ------------------------------------
if [[ "$SHELL" != "$(which zsh)" ]]; then
  echo "🐚 Changing shell to zsh..."
  chsh -s "$(which zsh)"
fi

# ------------------------------------
# STEP 9: Clone and install Dracula Terminal theme non-interactively
# ------------------------------------
echo "🎨 Installing Dracula GNOME Terminal theme..."

REPOS_DIR="$DOTFILES_DIR/repos"
DRACULA_DIR="$REPOS_DIR/gnome-terminal"
mkdir -p "$REPOS_DIR"

if [ ! -d "$DRACULA_DIR" ]; then
  git clone https://github.com/dracula/gnome-terminal "$DRACULA_DIR"
fi

cd "$DRACULA_DIR"

# Patch installer to run non-interactively
export INSTALL_PROFILE="Default"
export INSTALL_SCHEME="Dracula"
export CONFIRM="YES"

bash install.sh <<< "$(echo -e "1\n1\nYES")" >/dev/null 2>&1 || echo "⚠️ Dracula install script may have failed. Check terminal manually."

cd "$DOTFILES_DIR"

# ------------------------------------
# STEP 10: Set Nerd Font and make Dracula profile default
# ------------------------------------
echo "🎯 Searching for Dracula terminal profile..."
PROFILE_SLUG=""
for uuid in $(gsettings get org.gnome.Terminal.ProfilesList list | tr -d "[],'"); do
  name=$(dconf read /org/gnome/terminal/legacy/profiles:/:$uuid/visible-name | tr -d "'")
  if [ "$name" = "Dracula" ]; then
    PROFILE_SLUG=$uuid
    break
  fi
done

if [ -n "$PROFILE_SLUG" ]; then
  dconf write /org/gnome/terminal/legacy/profiles:/:$PROFILE_SLUG/use-system-font false
  dconf write /org/gnome/terminal/legacy/profiles:/:$PROFILE_SLUG/font "'JetBrainsMono Nerd Font 12'"
  dconf write /org/gnome/terminal/legacy/profiles:/default "'$PROFILE_SLUG'"
  echo "✅ Dracula profile configured with Nerd Font and set as default."
else
  echo "⚠️ Dracula profile not found. Please configure manually."
fi

echo "✅ All done!"
echo "📎 Open GNOME Terminal → Preferences → confirm 'Dracula' is default."
echo "🔁 Restart terminal and run: 'zsh' and 'nvim'"

