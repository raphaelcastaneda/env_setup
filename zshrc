# Interactive zsh config

# ---------------------------------------------------------------------------
# Zsh Options
# ---------------------------------------------------------------------------

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY

setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS

# ---------------------------------------------------------------------------
# Completion System
# ---------------------------------------------------------------------------

autoload -Uz compinit
compinit

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# ---------------------------------------------------------------------------
# Antidote Plugin Manager
# ---------------------------------------------------------------------------

if (( $+commands[brew] )) && [[ -d "$(brew --prefix antidote 2>/dev/null)" ]]; then
  source "$(brew --prefix antidote)/share/antidote/antidote.zsh"
elif [[ -f "$HOME/.antidote/antidote.zsh" ]]; then
  source "$HOME/.antidote/antidote.zsh"
fi
antidote load "${ZDOTDIR:-$HOME}/.zsh_plugins.txt"

# ---------------------------------------------------------------------------
# Starship Prompt
# ---------------------------------------------------------------------------

eval "$(starship init zsh)"

# ---------------------------------------------------------------------------
# Editor
# ---------------------------------------------------------------------------

if (( $+commands[nvim] )); then
  export EDITOR=nvim
  alias vim='nvim'
fi

# ---------------------------------------------------------------------------
# Aliases
# ---------------------------------------------------------------------------

# Platform-conditional ls
case "$OSTYPE" in
  linux*) alias ls='ls --color=auto -p' ;;
  darwin*) alias ls='ls -Gp' ;;
esac

alias ll='ls -la'
alias tmux='tmux -2'
alias pudb='python -m pudb'
alias ssh="TERM=xterm-256color ssh"

if [[ $KITTY_WINDOW_ID ]]; then
  alias icat='kitten icat'
fi

# Poetry
alias rmpoetry='poetry env remove'
alias activateenv='eval "$(poetry env activate)"'
alias pea='activateenv'

# Docker / Kubernetes
alias devcluster='colima start --arch aarch64 --vm-type=vz --vz-rosetta --kubernetes'

# Git
alias gaa='git add --all'
alias gc='git commit'
alias gp='git push origin HEAD'
alias gs='git status -sb'
alias glog="git log --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
alias gco='git checkout'
alias gcl='git checkout -'
alias gcm='git checkout main'
alias gdel='git push origin --delete'
alias rebase-branch='git fetch && git rebase -i $(git merge-base main HEAD^^)'
alias rebase-main='git fetch && git rebase -i main'
alias grm='rebase-main'
alias grb='rebase-branch'
alias gmp='git pull --recurse-submodules'
alias gsu='git submodule update --init --recursive'
alias gsc='git submodule foreach --recursive git reset --hard HEAD && git submodule foreach --recursive git clean -fdx'

# Shortcuts
alias wiki="cd $HOME/vimwiki && vim -c VimwikiIndex"

# ---------------------------------------------------------------------------
# Tool Completions
# ---------------------------------------------------------------------------

if (( $+commands[colima] )); then
  source <(colima completion zsh)
fi

if (( $+commands[kubectl] )); then
  source <(kubectl completion zsh)
  alias k='kubectl'
fi

# ---------------------------------------------------------------------------
# FZF
# ---------------------------------------------------------------------------

export FZF_COMPLETION_TRIGGER='**'
export FZF_COMPLETION_OPTS='-x --border --info=inline --height=60%'
export FZF_PREVIEW_COLUMNS=120
export FZF_PREVIEW_LINES=60

[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

if (( $+functions[_fzf_setup_completion] )); then
  _fzf_setup_completion path nvim open cat bat cp mv rm dir tree cd ls vim
fi

# Use fd for fzf path/directory completion
_fzf_compgen_path() {
  fd --type f --color always --hidden --follow --exclude ".git" . "$1"
}

_fzf_compgen_dir() {
  fd --color always --type d --hidden --follow --exclude ".git" . "$1"
}

_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    export|unset) fzf --ansi --multi --preview "eval 'echo \$'{}" "$@" ;;
    ssh) fzf --ansi --multi --preview 'dig {}' "$@" ;;
    *) fzf --ansi --multi --preview 'bash fzf-preview.sh {}' "$@" ;;
  esac
}

# fzf-help
if [[ -f "$HOME/.local/share/fzf-help/fzf-help.zsh" ]]; then
  source "$HOME/.local/share/fzf-help/fzf-help.zsh"
  export FZF_HELP_SYNTAX='help'
  zle -N fzf-help-widget
  bindkey '^H' fzf-help-widget
fi

# ---------------------------------------------------------------------------
# thefuck
# ---------------------------------------------------------------------------

if [[ -o interactive ]] && (( $+commands[thefuck] )); then
  eval "$(thefuck --alias oops)"
fi

# ---------------------------------------------------------------------------
# Functions
# ---------------------------------------------------------------------------

function setup_ssh_agent {
  if
    echo "List of running SSH agents:"
    pgrep -u $USER ssh-agent
  then
    return
  else
    echo -n "None found. Starting one... "
    . <(ssh-agent -s)
  fi
}

function fix_ssh_agent {
  if [[ -z "$(pgrep ssh-agent)" ]]; then
    rm -rf /tmp/ssh-*
    eval "$(ssh-agent -s)" > /dev/null
  else
    export SSH_AGENT_PID=$(pgrep ssh-agent)
    export SSH_AUTH_SOCK=$(find /tmp/ssh-* -name agent.* 2>/dev/null)
  fi
}

function dev {
  cd "$HOME/code/$1" || return
  [[ -f .env ]] && source .env
  if [[ -f poetry.lock ]]; then
    local activate_cmd
    activate_cmd="$(poetry env activate 2>/dev/null)"
    if [[ -n "$activate_cmd" ]]; then
      eval "$activate_cmd"
    fi
  fi
}

_dev() { _files -W "$HOME/code" -/ }
compdef _dev dev

# ---------------------------------------------------------------------------
# Machine-specific secrets
# ---------------------------------------------------------------------------

[[ -f ~/.env ]] && source ~/.env

# ---------------------------------------------------------------------------
# Keybindings
# ---------------------------------------------------------------------------

# History substring search on arrow keys (plugin is deferred, but bindings
# are picked up once the widget is available)
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^ ' autosuggest-accept
