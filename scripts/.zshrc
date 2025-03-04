alias vim="nvim"
alias cat="bat"

export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools
export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home

eval "$(ssh-agent -s)"
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

# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/peter/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions
