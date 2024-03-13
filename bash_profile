#PS4='+ $(date "+%s.%N")\011 '
#exec 3>&2 2>/tmp/bashstart.$$.log
#set -x

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
