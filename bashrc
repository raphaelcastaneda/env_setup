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
alias rebase-branch='git rebase -i `git merge-base master HEAD^^`'
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

# Automatically add completion for all aliases to commands having completion functions
function alias_completion {
    local namespace="alias_completion"

    # parse function based completion definitions, where capture group 2 => function and 3 => trigger
    local compl_regex='complete( +[^ ]+)* -F ([^ ]+) ("[^"]+"|[^ ]+)'
    # parse alias definitions, where capture group 1 => trigger, 2 => command, 3 => command arguments
    local alias_regex="alias ([^=]+)='(\"[^\"]+\"|[^ ]+)(( +[^ ]+)*)'"

    # create array of function completion triggers, keeping multi-word triggers together
    eval "local completions=($(complete -p | sed -Ene "/$compl_regex/s//'\3'/p"))"
    (( ${#completions[@]} == 0 )) && return 0

    # create temporary file for wrapper functions and completions
    rm -f "/tmp/${namespace}-*.tmp" # preliminary cleanup
    local tmp_file; tmp_file="$(mktemp "/tmp/${namespace}-${RANDOM}XXX.tmp")" || return 1

    local completion_loader; completion_loader="$(complete -p -D 2>/dev/null | sed -Ene 's/.* -F ([^ ]*).*/\1/p')"

    # read in "<alias> '<aliased command>' '<command args>'" lines from defined aliases
    local line; while read line; do
        eval "local alias_tokens; alias_tokens=($line)" 2>/dev/null || continue # some alias arg patterns cause an eval parse error
        local alias_name="${alias_tokens[0]}" alias_cmd="${alias_tokens[1]}" alias_args="${alias_tokens[2]# }"

        # skip aliases to pipes, boolean control structures and other command lists
        # (leveraging that eval errs out if $alias_args contains unquoted shell metacharacters)
        eval "local alias_arg_words; alias_arg_words=($alias_args)" 2>/dev/null || continue
        # avoid expanding wildcards
        read -a alias_arg_words <<< "$alias_args"

        # skip alias if there is no completion function triggered by the aliased command
        if [[ ! " ${completions[*]} " =~ " $alias_cmd " ]]; then
            if [[ -n "$completion_loader" ]]; then
                # force loading of completions for the aliased command
                eval "$completion_loader $alias_cmd"
                # 124 means completion loader was successful
                [[ $? -eq 124 ]] || continue
                completions+=($alias_cmd)
            else
                continue
            fi
        fi
        local new_completion="$(complete -p "$alias_cmd")"

        # create a wrapper inserting the alias arguments if any
        if [[ -n $alias_args ]]; then
            local compl_func="${new_completion/#* -F /}"; compl_func="${compl_func%% *}"
            # avoid recursive call loops by ignoring our own functions
            if [[ "${compl_func#_$namespace::}" == $compl_func ]]; then
                local compl_wrapper="_${namespace}::${alias_name}"
                    echo "function $compl_wrapper {
                        (( COMP_CWORD += ${#alias_arg_words[@]} ))
                        COMP_WORDS=($alias_cmd $alias_args \${COMP_WORDS[@]:1})
                        (( COMP_POINT -= \${#COMP_LINE} ))
                        COMP_LINE=\${COMP_LINE/$alias_name/$alias_cmd $alias_args}
                        (( COMP_POINT += \${#COMP_LINE} ))
                        $compl_func
                    }" >> "$tmp_file"
                    new_completion="${new_completion/ -F $compl_func / -F $compl_wrapper }"
            fi
        fi

        # replace completion trigger by alias
        new_completion="${new_completion% *} $alias_name"
        echo "$new_completion" >> "$tmp_file"
    done < <(alias -p | sed -Ene "s/$alias_regex/\1 '\2' '\3'/p")
    source "$tmp_file" && rm -f "$tmp_file"
}; alias_completion



eval "$(thefuck --alias)"
