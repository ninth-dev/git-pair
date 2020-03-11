#!/bin/bash

git-pair() {
  if [ $# -eq 0 ]; then
    echo "Usage: git-pair <alias>"
    return 1
  fi
  # check if it's a git repo
  # append the previous commit with the pair name and email
  # if there's exist pair append the previous commit with the pair name and email
  local pair_alias="${1}"
  local pair
  local new_message

  pair=$(cat $HOME/.git-pair | grep "${pair_alias}" | cut -d" " -f2-)
  prev_message=$(git log --format=%B -n -1)
  new_message="${prev_message}"$'\n\nCo-authored-by: '"${pair}"
  git commit --amend --message "$new_message"
  # undo-all -- search for all the Co-authored-by and remove
  # undo -- search for the last Co-authored-by and remove
}

_git_pair_completion() {
  local command="$1"
  local word="$2"
  local options=$(cat $HOME/.git-pair | awk '{print $1}')
  COMPREPLY=($(compgen -W "${options}" -- ${word}))
  return 0
}

complete -F _git_pair_completion git-pair
