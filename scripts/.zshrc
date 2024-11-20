alias vim="nvim"
alias cat="bat"

eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source <(fzf --zsh)

if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

  autoload -Uz compinit
  compinit
fi

bindkey -s ^N "tmux-proj\n"
bindkey "^[[1;3C" forward-word
bindkey "^[[1;3D" backward-word
