# Environment variables and PATH for all zsh sessions (interactive, scripts, login)
# Keep this minimal -- only truly universal settings belong here.

# Neovim if it exists, or fallback to vim
if [ -x "$(command -v nvim)" ]; then
  export EDITOR=nvim
else
  export EDITOR=vim
fi
export LANG='en_US.UTF-8'
export XDG_CONFIG_HOME="$HOME/.config"
export BAT_THEME='Tomorrow-Night'

# Build tools
export CMAKE_C_COMPILER_LAUNCHER=ccache
export CMAKE_CXX_COMPILER_LAUNCHER=ccache

# Language version managers
export PYENV_ROOT="$HOME/.pyenv"
export GOENV_ROOT="$HOME/.goenv"
export NVM_DIR="$HOME/.nvm"

# Java (only if java_home utility exists)
if [[ -x /usr/libexec/java_home ]]; then
  export JAVA_HOME="$(/usr/libexec/java_home 2>/dev/null)"
fi

# Deduplicate PATH automatically
typeset -U path

path=(
  /opt/homebrew/bin
  $PYENV_ROOT/bin
  $GOENV_ROOT/bin
  $HOME/bin
  $HOME/.bin
  $HOME/.local/bin
  $HOME/.cargo/bin
  $HOME/.nix-profile/bin
  $HOME/.yarn/bin
  $HOME/.config/yarn/global/node_modules/.bin
  /opt/local/bin
  /opt/local/sbin
  /usr/local/sbin
  $path
)
