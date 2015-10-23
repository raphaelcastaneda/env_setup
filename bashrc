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
source /usr/local/bin/virtualenvwrapper.sh
