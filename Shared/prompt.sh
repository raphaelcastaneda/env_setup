blk='\[\e[0;30m\]' # Black - Regular
red='\[\e[0;31m\]' # Red
grn='\[\e[0;32m\]' # Green
ylw='\[\e[0;33m\]' # Yellow
blu='\[\e[0;34m\]' # Blue
pur='\[\e[0;35m\]' # Purple
cyn='\[\e[0;36m\]' # Cyan
wht='\[\e[0;37m\]' # White
rst='\[\e[0m\]'    # Text Reset

function git_info {
  git rev-parse --is-inside-work-tree &> /dev/null;
  if [ $? -eq 0 ]; then
    __git_branch="`git branch 2> /dev/null | grep -e ^* | sed 's/* //'`"
    echo "$(printf '(%s)' $__git_branch)"
  fi
}
function git_changes {
  git rev-parse --is-inside-work-tree &> /dev/null;
  if [ $? -eq 0 ]; then
    echo `git status` | grep "nothing to commit" > /dev/null 2>&1
    if [ $? -ne 0 ]; then
      echo '<!> '
    fi
  fi
}

# Nice PS1 line
export PROMPT_COMMAND=__prompt_command
function __prompt_command() {
  local EXIT="$?"

  PS1=""
  if [ -n "$SSH_TTY" ]; then
    PS1+="$pur"
  else
    PS1+="$cyn"
  fi
  PS1+="\h $wht- $ylw\W $red"'$(git_changes)'"$grn"'$(git_info)'"\n"

  if [ $EXIT != 0 ]; then
    PS1+="$red"
  else
    PS1+="$grn"
  fi
  PS1+="\$$rst "
}
