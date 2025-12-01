#!/bin/bash

PROMPT_COMMAND='build_ps1'

COLOR_RESET="\[\e[0m\]"
COLOR_RED="\[\e[31m\]"
COLOR_GREEN="\[\e[32m\]"
COLOR_PURPLE="\[\e[95m\]"
COLOR_YELLOW="\[\e[33m\]"
COLOR_BLUE="\[\e[1;34m\]"

# Returns 3 characters
last_code_prompt()
{
  local ret_code="${1:-0}"
  # Adds spaces so that we get always 3 characters
  if [ $ret_code -eq 0 ]; then
    echo -n "( ${COLOR_GREEN}-${COLOR_RESET} )"
  else
    local ret_str=''
    if [ $ret_code -lt 10 ]; then
      ret_str+=" ${ret_code} "
    elif [ $ret_code -lt 100 ]; then
      ret_str+="${ret_code} "
    else
      ret_str+="${ret_code}"
    fi
    # Prompt syntax with red
    echo -n "(${COLOR_RED}${ret_str}${COLOR_RESET})"
  fi
}

# Returns a string with Git related information (when in a Git repository folder)
git_prompt() {
  local GitName
  GitName=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo '')
  if [ -n "$GitName" ]; then
    local GitBaseColor="${COLOR_PURPLE}"
    local GitHash
    GitHash=$(git rev-parse --short HEAD 2>/dev/null || echo '')

    # Commit count between local state and origin
    local GitCommitCount
    local GitStatusColor="${COLOR_RED}"
    GitCommitCount=$(git shortlog -s "origin/${GitName}..HEAD" 2>/dev/null)
    if [ "$?" -ne 0 ]; then
      GitCommitCount='x'
    elif [ -z "${GitCommitCount}" ]; then
      GitStatusColor="${COLOR_GREEN}"
      GitCommitCount='-'
    else
      GitCommitCount="$(echo -n "${GitCommitCount}" | xargs | cut -d' ' -f1 | head -n1)"
      if [[ "${GitCommitCount}" =~ [0-9]+ ]]; then
        if [ "${GitCommitCount}" -eq 0 ]; then
          GitStatusColor="${COLOR_GREEN}"
          GitCommitCount='-'
        elif [ "${GitCommitCount}" -gt 0 ]; then
          GitCommitCount="^${GitCommitCount}"
        elif [ "${GitCommitCount}" -lt 0 ]; then
          GitCommitCount="!${GitCommitCount}"
        fi
      else
        GitCommitCount='?'
      fi
    fi
    echo -n "${GitBaseColor}[ ${GitName} ${GitHash}${COLOR_RESET}"
    echo -n " ${GitStatusColor}${GitCommitCount}${COLOR_RESET}"
    echo -n "${GitBaseColor} ]${COLOR_RESET}"
  else
    # Nothing otherwise
    echo -n ' '
  fi
}

# Prompt function
build_ps1()
{
  local ret_code="${?:-0}" # Must be the first line
  PS1=''
  # Updates terminal title
  PS1+="\[\e]0;\W\a\]"
  # Last command return code
  PS1+="$(last_code_prompt "$ret_code")"
  # The user+host
  #PS1+='\[\e[01;32m\]\u@\h'
  # Time
  #PS1+=" ${COLOR_YELLOW}\t${COLOR_RESET}"
  # Adds the path
  PS1+=" ${COLOR_BLUE}\W${COLOR_RESET}"
  # Git info
  PS1+="$(git_prompt)"
  # Displays either $ or # (if root)
  # (The line break solves command display issues)
  PS1+="\n${COLOR_YELLOW}\$ ${COLOR_RESET}"
}
