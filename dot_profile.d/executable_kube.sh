#!/bin/bash

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

