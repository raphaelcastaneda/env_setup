# Login shell config -- runs once per login session.
# Tool initialization that should only happen once goes here.

# Homebrew
if [[ "$OSTYPE" == darwin* ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Pyenv
if (( $+commands[pyenv] )); then
  eval "$(pyenv init --path)"
  eval "$(pyenv init -)"
  export WORKON_HOME="$HOME/code/venv"
  export VIRTUALENVWRAPPER_PYTHON="$(which python)"
  pyenv virtualenvwrapper_lazy
fi

# Goenv
if (( $+commands[goenv] )); then
  eval "$(goenv init -)"
  path=("$(go env GOPATH)/bin" $path)
  export GOPATH="$(go env GOPATH)"
fi

# Google Cloud SDK
[[ -f ~/Downloads/google-cloud-sdk/path.zsh.inc ]] && source ~/Downloads/google-cloud-sdk/path.zsh.inc
[[ -f ~/Downloads/google-cloud-sdk/completion.zsh.inc ]] && source ~/Downloads/google-cloud-sdk/completion.zsh.inc
