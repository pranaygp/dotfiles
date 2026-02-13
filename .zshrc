fpath=(~/.zsh/completion $fpath)

# Setup homebrew path. Needs to be done early ahead of .path
# Inlined from `brew shellenv` to avoid forking on every shell start
if [ -x /opt/homebrew/bin/brew ]; then
  export HOMEBREW_PREFIX="/opt/homebrew"
  export HOMEBREW_CELLAR="/opt/homebrew/Cellar"
  export HOMEBREW_REPOSITORY="/opt/homebrew"
  export PATH="/opt/homebrew/bin:/opt/homebrew/sbin${PATH+:$PATH}"
  export MANPATH="/opt/homebrew/share/man${MANPATH+:$MANPATH}:"
  export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}"
elif [ -x /usr/local/bin/brew ]; then
  export HOMEBREW_PREFIX="/usr/local"
  export HOMEBREW_CELLAR="/usr/local/Cellar"
  export HOMEBREW_REPOSITORY="/usr/local/Homebrew"
  export PATH="/usr/local/bin:/usr/local/sbin${PATH+:$PATH}"
  export MANPATH="/usr/local/share/man${MANPATH+:$MANPATH}:"
  export INFOPATH="/usr/local/share/info:${INFOPATH:-}"
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""
DISABLE_AUTO_TITLE="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Set terminal title to current directory name
autoload -Uz add-zsh-hook
_set_terminal_title() {
  echo -ne "\e]0;${PWD##*/}\a"
}
add-zsh-hook precmd _set_terminal_title

# This is run by zsh-vim-mode to reset the old history search
function zvm_before_init() {
  zvm_bindkey viins '^[[A' history-beginning-search-backward
  zvm_bindkey viins '^[[B' history-beginning-search-forward
  zvm_bindkey vicmd '^[[A' history-beginning-search-backward
  zvm_bindkey vicmd '^[[B' history-beginning-search-forward
}

# Configure zsh-vi-mode
function zvm_config() {
  # Don't append mode indicator to prompt
  # ZVM_VI_EDITOR='none'
  # ZVM_INSERT_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BLOCK
  # ZVM_NORMAL_MODE_CURSOR=$ZVM_CURSOR_BLOCK
}

# Initialize starship AFTER zsh-vi-mode
function zvm_after_init() {
  eval "$(starship init zsh)"
}

# fnm setup (~3ms, not worth lazy-loading)
if [ -d "$HOME/.local/share/fnm" ]; then
  export PATH="$HOME/.local/share/fnm:$PATH"
  eval "$(fnm env --use-on-cd --shell zsh)"
fi

if [[ "$TERM_PROGRAM" == "vscode" ]]; then
  plugins=(git zoxide fzf aws zsh-completions zsh-autosuggestions zsh-syntax-highlighting)
else
  plugins=(git zoxide fzf aws zsh-vi-mode zsh-completions zsh-autosuggestions zsh-syntax-highlighting)
fi

source $ZSH/oh-my-zsh.sh
source $HOME/.profile

# Initialize starship for VSCode (zsh-vi-mode handles it otherwise)
if [[ "$TERM_PROGRAM" == "vscode" ]]; then
  eval "$(starship init zsh)"
fi

# User configuration

# Note: compinit is handled by oh-my-zsh above, no need to call it again

# Setup direnv if available
if command -v direnv &>/dev/null; then
  eval "$(direnv hook zsh)"
fi


# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/google-cloud-sdk/path.zsh.inc"; fi
# The next line enables shell command completion for gcloud.
if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/google-cloud-sdk/completion.zsh.inc"; fi

# Setup aws CLI completion
AWS_COMPLETER=$(which aws_completer)
if [ -f "$AWS_COMPLETER" ]; then
  complete -C "$AWS_COMPLETER" aws
fi


# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# Graphite CLI completion
#compdef gt
###-begin-gt-completions-###
#
# yargs command completion script
#
# Installation: gt completion >> ~/.zshrc
#    or gt completion >> ~/.zprofile on OSX.
#
_gt_yargs_completions()
{
  local reply
  local si=$IFS
  IFS=$'
' reply=($(COMP_CWORD="$((CURRENT-1))" COMP_LINE="$BUFFER" COMP_POINT="$CURSOR" gt --get-yargs-completions "${words[@]}"))
  IFS=$si
  _describe 'values' reply
}
compdef _gt_yargs_completions gt
###-end-gt-completions-###

