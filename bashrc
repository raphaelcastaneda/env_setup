export EDITOR=nvim
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
alias vim='nvim'

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

# Have a bin folder in my home directory
export PATH="$PATH:$HOME/.bin"

# Source completions
source $HOME/env_setup/completion/git.sh
source $HOME/env_setup/completion/hub.sh

# Virtualenvwrapper
export WORKON_HOME=$HOME/code/venv
export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python
source /usr/local/bin/virtualenvwrapper.sh

# Set alias for thefuck
eval "$(thefuck --alias oops)"

# FZF
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

export FZF_COMPLETION_TRIGGER='**'

# Options to fzf command
export FZF_COMPLETION_OPTS='+c -x'

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
