#!/bin/bash

PROMPT_COMMAND='build_ps1'

COLOR_RESET="$(tput sgr0)"
COLOR_RED="$(tput setaf 1)"
COLOR_GREEN="$(tput setaf 2)"
COLOR_PURPLE="$(tput setaf 5)"
COLOR_YELLOW="$(tput setaf 3)"

# Returns 3 characters
last_code_prompt()
{
  local ret_code="${?:-0}" # Must be the first line
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

build_ps1()
{
  PS1=''
  # Updates terminal title
  PS1+='\[\e]0;\w\a\]'
  # Last command return code
  PS1+='$(last_code_prompt)'
  # The user+host
  #PS1+='\[\033[01;32m\]\u@\h'
  # Adds the path
  PS1+=' \[\033[01;34m\]\w'
  # Git info
  PS1+='$(git_prompt)'
  # Displays either $ or # (if root)
  PS1+="${COLOR_YELLOW}> ${COLOR_RESET}"
}
