#!/bin/bash

git-pair() {
  if [ $# -eq 0 ]; then
    echo "Usage: git-pair <alias>"
    return 1
  fi

  local pair
  local pair_alias="${1}"
  local prev_message
  local prev_message_without_co_authors
  local co_authors
  local new_co_author
  local new_message

  pair=$(
    command grep "${pair_alias}" "${HOME}/.git-pair" \
    | cut -d" " -f2-
  )

  prev_message=$(git log --format=%B --max-count=1)

  prev_message_without_co_authors=$(
    echo "$prev_message" \
    | command grep -v "Co-authored-by: "
  )

  new_co_author="Co-authored-by: ${pair}"

  co_authors=$(
    echo "$prev_message" \
    | command grep "Co-authored-by: " \
    | cat - <(echo "$new_co_author") \
    | LC_ALL=c sort -u
  )

  new_message="${prev_message_without_co_authors}"$'\n\n'"${co_authors}"

  if [ "$new_message" != "$prev_message" ]; then
    git commit --amend --message "$new_message" --quiet
    echo "🍐'd with ${pair}"
  else
    echo "Already 🍐'd with ${pair}"
  fi
}

_git_pair_completion() {
  local options
  local word="${2}"
  options=$(awk '{print $1}' "${HOME}/.git-pair")
  COMPREPLY=($(compgen -W "${options}" -- ${word}))
}

complete -F _git_pair_completion git-pair
