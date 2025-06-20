# Benchmarking
#PS4='+ $(date "+%s.%N")\011 '
#exec 3>&2 2>/tmp/bashstart.$$.log
#set -x

export EDITOR=vim
[ "${PATH#*$HOME/bin:}" == "$PATH" ] && export PATH="$HOME/bin:$PATH"
export LANG='en_US.UTF-8'
export XDG_CONFIG_HOME="$HOME/.config"
#export TERM=screen-256color-bce
export BAT_THEME='Tomorrow-Night'

# truncate prompt.sh \w output
export PROMPT_DIRTRIM=3

#stty start undef
#stty stop undef

# History
export HISTSIZE=5000
export HISTFILESIZE=10000
export HISTCONTROL=ignoredups:erasedups # no duplicate entries
shopt -s histappend                     # append history file
# Save and reload the history after each command finishes
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"
#export PROMPT_COMMAND='history -a'      # update histfile after every command

# Ls
platform=$(uname)
if [[ $platform == 'Linux' ]]; then
	alias ls='ls --color=auto -p'
elif [[ $platform == 'Darwin' ]]; then
	alias ls='ls -Gp'
fi

#####
# Aliases
alias ll='ls -la'
#alias clean='find . -name '*.DS_Store' -type f -delete'
alias tmux='tmux -2'
#alias xclip='xclip -selection c'
alias pudb='python -m pudb' # make sure pudb works even in a virtualenv
alias bashtop='bpytop'      # python implementation of bashtop is the new bashtop
if [ -x "$(command -v nvim)" ]; then
	export EDITOR=nvim
	alias vim='nvim'
fi
alias devcluster='colima start --arch aarch64 --vm-type=vz --vz-rosetta --kubernetes'

alias ssh="TERM=xterm-256color ssh"
# if this is kitty, set up image previewing
if [[ $KITTY_WINDOW_ID ]]; then
	alias icat='kitten icat'
fi

alias rmpoetry='poetry env remove'
alias activateenv='$(poetry env activate)'
alias pea='activateenv'

#####
# Git aliases
alias gaa='git add --all'
alias gc='git commit'
alias gp='git push origin HEAD'
alias gs='git status -sb'
alias glog="git log --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
alias gco='git checkout'
alias gcl='git checkout -'
alias gcm='git checkout main'
alias gdel='git push origin --delete'
alias rebase-branch='git rebase -i `git merge-base main HEAD^^`'
alias grb='rebase-branch'
alias gmp='git pull --recurse-submodules'
alias gsu='git submodule update --init --recursive'

# git clean each submodule
alias gsc='git submodule foreach --recursive git reset --hard HEAD && git submodule foreach --recursive git clean -fdx'

#####
# Ansible aliases
#alias asv='ansible-vault '
#alias asp='ansible-playbook --ask-vault-pass -v '

# Handy shortcuts
alias wiki="cd $HOME/vimwiki && vim -c VimwikiIndex"

#####
# Shell PS1 line & base dir & .env
source "${HOME}/env_setup/prompt.sh"

# Those are computer specific config / secrets
source "${HOME}/.env"

# Tmuxinator
#source ~/.bin/tmuxinator.bash

# Have a bin folder in my home directory
[ "${PATH#*$HOME/.bin:}" == "$PATH" ] && export PATH="$PATH:$HOME/.bin"
[ "${PATH#*$HOME/.local/bin:}" == "$PATH" ] && export PATH="$PATH:$HOME/.local/bin"

# Set up Go vars and path -- DEPRECATED: using goenv
#export GOPATH=$(go env GOPATH)
#export GOROOT=$(go env GOROOT)

# Add rust path
[ "${PATH#*$HOME/.cargo/bin:}" == "$PATH" ] && export PATH="${HOME}/.cargo/bin:$PATH"

# Add nix to the path
[ "${PATH#*$HOME/.nix-profile/bin:}" == "$PATH" ] && export PATH="${HOME}/.nix-profile/bin:$PATH"

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
#  HOMEBREW_PREFIX='$(brew --prefix)'
#  if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]; then
#    source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
#  else
#    for COMPLETION in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*; do
#      [[ -r "$COMPLETION" ]] && source "$COMPLETION"
#    done
#  fi
#fi

## Source completions (pre alias)
source "$HOME/env_setup/completion/git.sh"
#source $HOME/env_setup/completion/hub.sh

# Colima (docker runtime for mac)
if command -v colima &>/dev/null; then
	source <(colima completion bash)
fi

# Set kubectl completion if kubectl is installed
if command -v kubectl &>/dev/null; then
	source <(kubectl completion bash)
	alias k='kubectl'
	complete -o default -F __start_kubectl k
fi

# Use fd (https://github.com/sharkdp/fd) instead of the default find
# command for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
	fd --type f --color always --hidden --follow --exclude ".git" . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
	fd --color always --type d --hidden --follow --exclude ".git" . "$1"
}
#
# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
	local command=$1
	shift

	case "$command" in
	#cd)           fzf --preview 'tree -C {} | head -200'   "$@" ;;
	export | unset) fzf --ansi --multi --preview "eval 'echo \$'{}" "$@" ;;
	ssh) fzf --ansi --multi --preview 'dig {}' "$@" ;;
	*) fzf --ansi --multi --preview 'bash fzf-preview.sh {}' "$@" ;;
	esac
}
#
# Support completion on aliased commands
source "$HOME"/env_setup/completion/aliases.sh

## Source completions (post alias)
source "$HOME"/env_setup/completion/tmux.sh
source "$HOME"/env_setup/completion/terraform.sh

# Set alias for thefuck if the command exists
if command -v thefuck &>/dev/null; then
	eval "$(thefuck --alias oops)"
fi

[ "${PATH#*$HOME/.yarn/bin:}" == "$PATH" ] && export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
export NVM_DIR="$HOME/.nvm"
#[ -s "$NVM_DIR/nvm.sh"  ] && \. "$NVM_DIR/nvm.sh"
#[ -s "$NVM_DIR/bash_completion"  ] && \. "$NVM_DIR/bash_completion"
# eval "$(rbenv init -)"
export JAVA_HOME="$(/usr/libexec/java_home -v20.0.1)"

# Benchmarking
#set +x
#exec 2>&3 3>&-

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

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

function dev {
	cd "$HOME/code/$1" || return
	if [ -f ".env" ]; then
		source .env
	fi
	if [ -f "poetry.lock" ]; then
		poetry shell
	fi
}

# Make sure ssh agent is running
function fix_ssh_agent {
	if [ -z "$(pgrep ssh-agent)" ];
	then
		rm -rf /tmp/ssh-*
		eval "$(ssh-agent -s)" > /dev/null
	else
		export SSH_AGENT_PID=$(pgrep ssh-agent)
		export SSH_AUTH_SOCK=$(find /tmp/ssh-* -name agent.*)
	fi
}
