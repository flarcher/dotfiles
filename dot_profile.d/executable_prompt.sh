#!/bin/bash

PROMPT_COMMAND='build_ps1'

last_code_prompt()
{
  local ret_code="${?:-0}" # Must be the first line
  local ret_str=''
  local ret_length="${#ret_code}"
  # Adds spaces so that we get always 3 characters
  if [ $ret_length -lt 2 ]; then
    ret_str=" ${ret_code} "
  elif [ $ret_length -lt 3 ]; then
    ret_str=" ${ret_code}"
  else
    ret_str="${ret_code}"
  fi
  # Display a success differently from an error
  if [ $ret_code -eq 0 ]; then
    ret_color="$(tput setaf 2)" # Green
  else
    ret_color="$(tput setaf 1)" # Red
  fi
  # Prompt syntax
  echo -n "${ret_color}${ret_str}"
}

git_prompt() {
  local GitName
  GitName=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo '')
  if [ -n "$GitName" ]; then
    local GitBaseColor="$(tput setaf 5)"
    local GitHash
    GitHash=$(git rev-parse --short HEAD 2>/dev/null || echo '')

    # Commit count between local state and origin
    local GitCommitCount
    local GitStatusColor="$(tput setaf 9)" # Red
    GitCommitCount=$(git shortlog -s "origin/${GitName}..HEAD" 2>/dev/null)
    if [ "$?" -ne 0 ]; then
      GitCommitCount='x'
    else

      GitCommitCount="$(echo -n "${GitCommitCount}" | xargs | cut -d' ' -f1 | head -n1)"
      if [[ "${GitCommitCount}" =~ [0-9]+ ]]; then
        if [ "${GitCommitCount}" -eq 0 ]; then
          GitStatusColor="$(tput setaf 15)" # White
          GitCommitCount='-'
        elif [ "${GitCommitCount}" -gt 0 ]; then
          GitCommitCount="^${GitCommitCount}"
        elif [ "${GitCommitCount}" -lt 0 ]; then
          GitCommitCount="!${GitCommitCount}"
        fi
      elif [ -z "${GitCommitCount}" ]; then
        GitCommitCount='-'
      else
        GitCommitCount='?'
      fi
    fi
    echo -n "${GitBaseColor}[ "
    echo -n "${GitName} ${GitHash} ${GitStatusColor}${GitCommitCount}"
    echo -n "${GitBaseColor} ]"
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
  PS1+='\[\e[1;33m\]\$ '
  # Reset colors
  PS1+='\[\e[0m\]'
}
