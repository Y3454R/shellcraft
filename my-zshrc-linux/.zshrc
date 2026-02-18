# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="clean"

plugins=(git)

source $ZSH/oh-my-zsh.sh

# Autosuggestions
if [ -f "$HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
  source "$HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

# Syntax Highlighting (must be last)
if [ -f "$HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
  source "$HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# User configuration
# export LANG=en_US.UTF-8


# atuin (only load if installed)
if [ -f "$HOME/.atuin/bin/env" ]; then
  . "$HOME/.atuin/bin/env"
fi

if command -v atuin >/dev/null 2>&1; then
  eval "$(atuin init zsh)"
fi
