# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH.
fpath=(~/.zsh/completion $fpath)

# if type brew &>/dev/null; then
#   FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
# fi

# Setup homebrew path. Needs to be done early ahead of .path
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
# Disabled to use starship prompt instead
ZSH_THEME=""

# Set list of themes to load
# Setting this variable when ZSH_THEME=random
# cause zsh load theme from this variable instead of
# looking in ~/.oh-my-zsh/themes/
# An empty array have no effect
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true" # Should be done via dotfiles submodule

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"
function precmd() {
  echo -ne "\e]0;${PWD##*/}\a"
}

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

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

function zle-line-init zle-keymap-select {
  RPS1="${${KEYMAP/vicmd/-- NORMAL --}/(main|viins)/-- INSERT --}"
  RPS2=$RPS1
  zle reset-prompt
}

# Initialize starship AFTER zsh-vi-mode
function zvm_after_init() {
  eval "$(starship init zsh)"
}

zle -N zle-line-init
zle -N zle-keymap-select

# Configuration for the zsh omz plugin
# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/nvm
# if type brew &>/dev/null; then
#   NVM_HOMEBREW=$(brew --prefix nvm)
# fi

# Disabled nvm setup since we use fnm now (installed later)
# Lazy load NVM when any node based executable is run
# declare -a NODE_GLOBALS=(
#   $(
#     find ~/.nvm/versions/node -maxdepth 3 -type l -wholename '*/bin/*' \
#       ! -name 'node' \
#       ! -name 'npm' \
#       ! -name 'npx' \
#       ! -name 'pnpm' \
#       ! -name 'yarn' |
#       xargs -n1 basename | sort | uniq
#   )
# )
# zstyle ':omz:plugins:nvm' lazy yes
# zstyle ':omz:plugins:nvm' lazy-cmd "${NODE_GLOBALS[@]}"
# # Automatically load .nvmrc when found in a directory
# zstyle ':omz:plugins:nvm' autoload yes

# fnm setup (check if fnm exists first)
if command -v fnm &> /dev/null; then
  eval "$(fnm env --use-on-cd --shell zsh)"
fi

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
if [[ "$TERM_PROGRAM" == "vscode" ]]; then
  # plugins=(git zoxide fzf nvm aws zsh-syntax-highlighting)
  plugins=(git zoxide fzf aws zsh-syntax-highlighting)
else
  # plugins=(git zoxide fzf aws nvm zsh-vi-mode zsh-syntax-highlighting)
  plugins=(git zoxide fzf aws zsh-vi-mode zsh-syntax-highlighting)
fi

source $ZSH/oh-my-zsh.sh
source $HOME/.profile

# Initialize starship for VSCode (zsh-vi-mode handles it otherwise)
if [[ "$TERM_PROGRAM" == "vscode" ]]; then
  eval "$(starship init zsh)"
fi

# User configuration

autoload -Uz compinit
# Optimize compinit by only checking once a day
# Use different stat syntax for macOS vs Linux
if [[ "$(uname -s)" == "Darwin" ]]; then
  # macOS
  if [ $(date +'%j') != $(stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null || echo 0) ]; then
    compinit
  else
    compinit -C
  fi
else
  # Linux
  if [ $(date +'%j') != $(stat -c '%Y' ~/.zcompdump 2>/dev/null | xargs -I{} date -d @{} +'%j' 2>/dev/null || echo 0) ]; then
    compinit
  else
    compinit -C
  fi
fi

# The next line sets up the iterm2 shell integration for zsh
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"


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
[ -s "/Users/pranaygp/.bun/_bun" ] && source "/Users/pranaygp/.bun/_bun"

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

