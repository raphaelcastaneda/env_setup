#!/bin/bash
#
# DESCRIPTION:
#   Customized to look beautiful using the molokai terminal theme
#
#   Set the bash prompt according to:
#    * the active virtualenv
#    * the branch/status of the current git repository
#    * the return value of the previous command
#    * the fact you just came from Windows and are used to having newlines in
#      your prompts.
#
# USAGE:
#
#   1. Save this file as ~/.bash_prompt
#   2. Add the following line to the end of your ~/.bashrc or ~/.bash_profile:
#        . ~/.bash_prompt
#
# LINEAGE:
#
#   Based on work by woods
#
#   https://gist.github.com/31967
 
# The various escape codes that we can use to color our prompt.
        RED="\[\033[0;31m\]"
     YELLOW="\[\033[1;33m\]"
     ORANGE="\[\033[0;33m\]"
      GREEN="\[\033[0;32m\]"
       BLUE="\[\033[1;34m\]"
       CYAN="\[\033[1;36m\]"
  LIGHT_RED="\[\033[1;31m\]"
LIGHT_GREEN="\[\033[1;32m\]"
      WHITE="\[\033[1;37m\]"
 LIGHT_GRAY="\[\033[0;37m\]"
 COLOR_NONE="\[\e[0m\]"
 
# Detect whether the current directory is a git repository.
function is_git_repository {
  git branch > /dev/null 2>&1
}
 
# Determine the branch/state information for this git repository.
function set_git_branch {
  # Capture the output of the "git status" command.
  git_status="$(git status 2> /dev/null)"
 
  # Set color based on clean/staged/dirty.
  if [[ ${git_status} =~ "working directory clean" ]]; then
    state="${GREEN}"
  elif [[ ${git_status} =~ "Changes to be committed" ]]; then
    state="${YELLOW}"
  else
    state="${RED}"
  fi
 
  # Set arrow icon based on status against remote.
  remote_pattern="^(# )?Your branch is (ahead|behind)+ "
  if [[ ${git_status} =~ ${remote_pattern} ]]; then
    if [[ ${BASH_REMATCH[2]} == "ahead" ]]; then
      remote="↑"
    else
      remote="↓"
    fi
  else
    remote=""
  fi
  diverge_pattern="# Your branch and (.*) have diverged"
  if [[ ${git_status} =~ ${diverge_pattern} ]]; then
    remote="↕"
  fi
 
  # Get the name of the branch.
  branch_pattern="^(# )?On branch ([^${IFS}]*)"
  if [[ ${git_status} =~ ${branch_pattern} ]]; then
    branch=${BASH_REMATCH[2]}
  fi
 
  # Set the final branch string.
  BRANCH="${state}(${branch})${remote}${COLOR_NONE} "
}
 
# Return the prompt symbol to use, colorized based on the return value of the
# previous command.
function set_prompt_symbol () {
  if test $1 -eq 0 ; then
      PROMPT_SYMBOL="${GREEN}\$${COLOR_NONE}"
  else
      PROMPT_SYMBOL="${RED}\$${COLOR_NONE}"
  fi
}
 
# Determine active Python virtualenv details.
function set_virtualenv () {
  if test -z "$VIRTUAL_ENV" ; then
      PYTHON_VIRTUALENV=""
  else
      PYTHON_VIRTUALENV="${LIGHT_GREEN}[`basename \"$VIRTUAL_ENV\"`]${COLOR_NONE} "
  fi
}
 
# Echo out all the color choices for posterity
function echo_colors() {
    echo -e "${RED}RED${COLOR_NONE}"
    echo -e "${LIGHT_RED}LIGHT_RED${COLOR_NONE}"
    echo -e "${ORANGE}ORANGE${COLOR_NONE}"
    echo -e "${YELLOW}YELLOW${COLOR_NONE}"
    echo -e "${GREEN}GREEN${COLOR_NONE}"
    echo -e "${LIGHT_GREEN}LIGHT_GREEN${COLOR_NONE}"
    echo -e "${BLUE}BLUE${COLOR_NONE}"
    echo -e "${CYAN}CYAN${COLOR_NONE}"
    echo -e "${WHITE}WHITE${COLOR_NONE}"
    echo -e "${LIGHT_GRAY}LIGHT_GRAY${COLOR_NONE}"
}
 
# Set the full bash prompt.
function set_bash_prompt () {
  # Set the PROMPT_SYMBOL variable. We do this first so we don't lose the
  # return value of the last command.
  set_prompt_symbol $?
 
  # Set the PYTHON_VIRTUALENV variable.
  set_virtualenv
 
  # Set the BRANCH variable.
  if is_git_repository ; then
    set_git_branch
  else
    BRANCH=''
  fi
 
  # Set the bash prompt variable.
  PS1="
${PYTHON_VIRTUALENV}${CYAN}\h ${ORANGE}\w${COLOR_NONE} ${BRANCH}
${PROMPT_SYMBOL} "
}
 
# Tell bash to execute this function just before displaying its prompt.
PROMPT_COMMAND=set_bash_prompt
