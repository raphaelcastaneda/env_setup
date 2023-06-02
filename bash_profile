source ~/.bashrc

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"
export PATH="/usr/local/sbin:$PATH"

source /Users/racastaneda/.docker/init-bash.sh || true # Added by Docker Desktop
