export EDITOR=vim
export PATH=".:$HOME/bin:$PATH"

if [ -n "$DISPLAY" -a "$TERM" == "xterm" ]; then
    export TERM=xterm-256color
fi

#stty start undef
#stty stop undef

# History
export HISTSIZE=5000
export HISTFILESIZE=10000
export HISTCONTROL=ignoreboth:erasedups # no duplicate entries
shopt -s histappend                     # append history file
export PROMPT_COMMAND="history -a"      # update histfile after every command

# Ls
platform=`uname`
if [[ $platform == 'Linux' ]]; then
  alias ls='ls --color=auto -p'
elif [[ $platform == 'Darwin' ]]; then
  alias ls='ls -Gp'
fi


#####
# Aliases
alias ll='ls -la'
#alias clean='find . -name "*.DS_Store" -type f -delete'
alias tmux='tmux -2'
#alias xclip='xclip -selection c'
alias pudb='python -m pudb'  # make sure pudb works even in a virtualenv

#####
# Git aliases
alias gaa='git add --all'
alias gc='git commit'
alias gp='git push origin HEAD'
alias gs='git status -sb'
alias glog="git log --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
alias gco='git checkout'
alias gcl='git checkout -'
alias gcm='git checkout master'
alias gdel='git push origin --delete'
alias rebase-branch='git rebase -i `git merge-base master HEAD`'
alias grb='rebase-branch'
#####
# Ansible aliases
#alias asv='ansible-vault '
#alias asp='ansible-playbook --ask-vault-pass -v '

#####
# Shell PS1 line & base dir & .env
source $HOME/env_setup/prompt.sh

# Those are computer specific config / secrets
source $HOME/.env

# Tmuxinator
source ~/.bin/tmuxinator.bash

# Have a bin folder in my home directory
export PATH="$PATH:$HOME/.bin"

# Set up Go vars and path
# export GOROOT=/usr/local/opt/go/libexec
export GOPATH=$HOME/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin


# Make sure these statements execute before sourcing bash completion.
export NVM_DIR="${HOME}/.nvm"
if [[ -f /usr/local/opt/nvm/nvm.sh ]]; then
   .  /usr/local/opt/nvm/nvm.sh
fi

if [[ -e "/usr/local/share/bash-completion/bash_completion" ]]; then
	export BASH_COMPLETION_COMPAT_DIR="/usr/local/etc/bash_completion.d"
	source "/usr/local/share/bash-completion/bash_completion"
elif [[ -e "/usr/local/etc/profile.d/bash_completion.sh" ]]; then
	source "/usr/local/etc/profile.d/bash_completion.sh"
elif [[ -e "/etc/bash_completion" ]]; then
	source "/etc/bash_completion"
fi
# Brew completions
#if type brew &>/dev/null; then
#  HOMEBREW_PREFIX="$(brew --prefix)"
#  if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]; then
#    source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
#  else
#    for COMPLETION in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*; do
#      [[ -r "$COMPLETION" ]] && source "$COMPLETION"
#    done
#  fi
#fi

## Source completions
source $HOME/env_setup/completion/git.sh
#source $HOME/env_setup/completion/hub.sh
source $HOME/env_setup/completion/terraform.sh

# Set alias for thefuck
eval "$(thefuck --alias oops)"

# FZF
export FZF_COMPLETION_TRIGGER='**'

# Options to fzf command
export FZF_COMPLETION_OPTS='+c -x'

[ -f ~/.fzf.bash ] && source ~/.fzf.bash


# Use ag instead of the default find command for listing candidates.
# - The first argument to the function is the base path to start traversal
# - Note that ag only lists files not directories
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  ag -g "" "$1"
}


# Pyenv config. See https://github.com/yyuu/pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH:"
eval "$(pyenv init -)"

# Virtualenvwrapper
export WORKON_HOME=$HOME/code/venv
export VIRTUALENVWRAPPER_PYTHON=`which python`
pyenv virtualenvwrapper

# Wrap aliases for autocompletion
# wrap_alias takes three arguments:
# $1: The name of the alias
# $2: The command used in the alias
# $3: The arguments in the alias all in one string
# Generate a wrapper completion function (completer) for an alias
# based on the command and the given arguments, if there is a
# completer for the command, and set the wrapper as the completer for
# the alias.
function wrap_alias() {
  [[ "$#" == 3 ]] || return 1

  local alias_name="$1"
  local aliased_command="$2"
  local alias_arguments="$3"
  local num_alias_arguments=$(echo "$alias_arguments" | wc -w)

  # The completion currently being used for the aliased command.
  local completion=$(complete -p $aliased_command 2> /dev/null)

  # Only a completer based on a function can be wrapped so look for -F
  # in the current completion. This check will also catch commands
  # with no completer for which $completion will be empty.
  echo $completion | grep -q -- -F || return 0

  local namespace=alias_completion::

  # Extract the name of the completion function from a string that
  # looks like: something -F function_name something
  # First strip the beginning of the string up to the function name by
  # removing "* -F " from the front.
  local completion_function=${completion##* -F }
  # Then strip " *" from the end, leaving only the function name.
  completion_function=${completion_function%% *}

  # Try to prevent an infinite loop by not wrapping a function
  # generated by this function. This can happen when the user runs
  # this twice for an alias like ls='ls --color=auto' or alias l='ls'
  # and alias ls='l foo'
  [[ "${completion_function#$namespace}" != $completion_function ]] && return 0

  local wrapper_name="${namespace}${alias_name}"

  eval "
function ${wrapper_name}() {
  ((COMP_CWORD+=$num_alias_arguments))
  args=( \"${alias_arguments}\" )
  COMP_WORDS=( $aliased_command \${args[@]} \${COMP_WORDS[@]:1} )
  $completion_function
  }
"

  # To create the new completion we use the old one with two
  # replacements:
  # 1) Replace the function with the wrapper.
  local new_completion=${completion/-F * /-F $wrapper_name }
  # 2) Replace the command being completed with the alias.
  new_completion="${new_completion% *} $alias_name"

  eval "$new_completion"
}

# For each defined alias, extract the necessary elements and use them
# to call wrap_alias.
eval "$(alias -p | sed -e 's/alias \([^=][^=]*\)='\''\([^ ][^ ]*\) *\(.*\)'\''/wrap_alias \1 \2 '\''\3'\'' /')"

unset wrap_alias
