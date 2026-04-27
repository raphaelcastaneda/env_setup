# Login shell config -- runs once per login session.
# Tool initialization that should only happen once goes here.

_cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
[[ -d $_cache_dir ]] || mkdir -p $_cache_dir

# Homebrew. Cache shellenv output; regenerate only when the brew binary changes.
if [[ "$OSTYPE" == darwin* ]]; then
  _brew_env=$_cache_dir/brew_shellenv.zsh
  if [[ ! -s $_brew_env || /opt/homebrew/bin/brew -nt $_brew_env ]]; then
    /opt/homebrew/bin/brew shellenv > $_brew_env
  fi
  source $_brew_env
  unset _brew_env
fi

# Pyenv. Shims eagerly on PATH so python/pip resolve via pyenv; defer the
# heavy `pyenv init -` until first `pyenv` invocation.
if (( $+commands[pyenv] )); then
  path=("$PYENV_ROOT/shims" $path)
  export WORKON_HOME="$HOME/code/venv"
  pyenv() {
    unfunction pyenv
    eval "$(command pyenv init -)"
    export VIRTUALENVWRAPPER_PYTHON="$(whence -p python)"
    command pyenv virtualenvwrapper_lazy 2>/dev/null
    pyenv "$@"
  }
fi

# Goenv. Same pattern as pyenv. GOPATH cached to avoid `go env` subprocess.
if (( $+commands[goenv] )); then
  path=("$GOENV_ROOT/shims" $path)
  _gopath_cache=$_cache_dir/gopath
  if [[ ! -s $_gopath_cache || $GOENV_ROOT/shims/go -nt $_gopath_cache ]]; then
    command go env GOPATH > $_gopath_cache 2>/dev/null
  fi
  if [[ -s $_gopath_cache ]]; then
    export GOPATH="$(<$_gopath_cache)"
    path=("$GOPATH/bin" $path)
  fi
  unset _gopath_cache
  goenv() {
    unfunction goenv
    eval "$(command goenv init -)"
    goenv "$@"
  }
fi

unset _cache_dir

# Google Cloud SDK
[[ -f ~/Downloads/google-cloud-sdk/path.zsh.inc ]] && source ~/Downloads/google-cloud-sdk/path.zsh.inc
[[ -f ~/Downloads/google-cloud-sdk/completion.zsh.inc ]] && source ~/Downloads/google-cloud-sdk/completion.zsh.inc
