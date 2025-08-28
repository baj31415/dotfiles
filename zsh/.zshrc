ZSH_DISABLE_COMPFIX=true

source ~/.aliases

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="arrow"

plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  z
)

source $ZSH/oh-my-zsh.sh
if [ -f ~/.aliases ]; then
  source ~/.aliases
fi


# custom funsctions
open() {
  "$@" >/dev/null 2>&1 & disown
}

# custom paths
if [ -f "$HOME/.local/paths" ]; then
    source "$HOME/.local/paths"
fi

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/GTL/ubajpai/miniconda3/bin/conda' 'shell.zsh' 'hook' 2>/dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/GTL/ubajpai/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/GTL/ubajpai/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/GTL/ubajpai/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
