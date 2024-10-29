#!/bin/bash

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Runs shells from a docker container
alias docker-sh='docker run --rm -it --network=host --entrypoint=/bin/sh'
alias docker-bash='docker run --rm -it --network=host --entrypoint=/bin/bash'

#--- Git commands
alias gst='git status -s'
alias gl="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset' --date=short --all"
alias gdc='git diff --cached'
alias gd='git diff'
alias gm='git merge --no-commit --no-ff'
alias gr='git rebase'
alias gbl='git branch --list'
alias gc='git commit -m'
alias gca='git commit -a -m'
alias gsb='git switch '

# Generates a random password
alias random='openssl rand -base64 12'

# Updates the clock
alias clock-sync='sudo hwclock -s'

#--- Kubectl
if command -v kubectl > /dev/null; then
  source <(kubectl completion bash)
  alias k='kubectl'
  complete -o default -F __start_kubectl k
fi

# Lists all k8s resources in a namespace (first argument)
alias k8s-list-all='kubectl api-resources --verbs=list --namespaced -o name | xargs -n 1 kubectl get -n '

# Show last events in a namespace (first argument)
alias k8s-events='kubectl get events --sort-by="{.lastTimestamp}" -n '

# Exports the content of a secret into a file
function k8s-fetch-secret {
  local namespace="$1"
  local secret_name="$2"
  local file_name="$3"
  kubectl -n "${namespace}" get secret "${secret_name}" -o json | \
    jq -r ".data[\"${file_name}\"]" | \
    base64 -d > "${file_name}"
}