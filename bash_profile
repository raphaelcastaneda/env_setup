#PS4='+ $(date "+%s.%N")\011 '
#exec 3>&2 2>/tmp/bashstart.$$.log
#set -x

if [[ "$OSTYPE" == "darwin"* ]]; then
  eval $(/opt/homebrew/bin/brew shellenv)
fi

source "$HOME/.bashrc"


[ "${PATH#*/usr/local/sbin:}" == "$PATH" ] && export PATH="/usr/local/sbin:$PATH"

# Pyenv config. See https://github.com/pyenv/pyenv
export PYENV_ROOT="$HOME/.pyenv"
[ "${PATH#*$PYENV_ROOT/bin:}" == "$PATH" ] && export PATH="$PYENV_ROOT/bin:$PATH:"
eval "$(pyenv init -)"

# Virtualenvwrapper
export WORKON_HOME="$HOME/code/venv"
export VIRTUALENVWRAPPER_PYTHON=$(which python)
pyenv virtualenvwrapper_lazy

# Goenv config. See: https://github.com/go-nv/goenv/blob/master/INSTALL.md
export GOENV_ROOT="$HOME/.goenv"
if [ "${PATH#*$GOENV_ROOT/bin:}" == "$PATH" ]; then
    export PATH="$GOENV_ROOT/bin:$PATH"
    eval "$(goenv init -)"
    export PATH="$(go env GOPATH)/bin:$PATH"
fi
export GOPATH="$(go env GOPATH)"
#
# FZF

 export FZF_COMPLETION_TRIGGER='**'
 
 # Options to fzf command
 #export FZF_COMPLETION_OPTS='-x --border'
 export FZF_COMPLETION_OPTS='-x --border --info=inline --height=60%'
export FZF_PREVIEW_COLUMNS=120
export FZF_PREVIEW_LINES=60

 if [ -f "$HOME/.fzf.bash" ]; then
     source "$HOME/.fzf.bash"
    _fzf_setup_completion path nvim open cat bat cp mv rm dir tree cd ls vim
fi
#set +x
#exec 2>&3 3>&-

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/raphael/miniforge3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/raphael/miniforge3/etc/profile.d/conda.sh" ]; then
        . "/Users/raphael/miniforge3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/raphael/miniforge3/bin:$PATH"
    fi
fi
unset __conda_setup

if [ -f "/Users/raphael/miniforge3/etc/profile.d/mamba.sh" ]; then
    . "/Users/raphael/miniforge3/etc/profile.d/mamba.sh"
fi
# <<< conda initialize <<<

