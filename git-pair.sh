#!/usr/bin/env bash

# XXX - should use bash scripts instead of functions ??
# con: need to put script into PATH
# pro: no need to do crazy things like the line below
__GIT_PAIR_HOME="$(dirname "${BASH_SOURCE[0]:-${(%):-%x}}")"
source "${__GIT_PAIR_HOME}/git-pair-message-generate.sh"


git-pair-all() {
  local pair
  local pair_alias
  local current_head
  local unmerged
  local unmerged_commit

  if [ $# -eq 0 ]; then
    echo "Usage: git-pair-all <alias>"
    return 1
  else
    pair_alias="${1}"
  fi

  pair=$(
    command grep "${pair_alias}" "${HOME}/.git-pair" \
    | cut -d" " -f2-
  )

  current_head="$(git rev-parse --short HEAD)"
  echo '---------------'
  echo 'To revert:'
  echo "  \$ git reset --hard ${current_head}"
  echo '---------------'
  unmerged=$(git cherry master --abbrev --verbose)
  echo ""
  echo -n "${unmerged}\n"
  echo '---------------'
  unmerged_commit=$(echo "$unmerged" | awk '{print $2}' | head -n 1)

  command=$(
    PAIR="${pair}" \
    GIT_PAIR_MESSAGE_GENERATE="${__GIT_PAIR_HOME}/git-pair-message-generate.sh" \
    GIT_EDITOR="${__GIT_PAIR_HOME}/git-pair-editor.sh" \
    GIT_SEQUENCE_EDITOR="sed -i -e 's/pick/reword/g'" \
      git rebase \
        --interactive \
        --committer-date-is-author-date \
        --quiet "${unmerged_commit:-"HEAD"}"~1 > /dev/null
  )

  if $command; then
    echo "🍐'd with ${pair}"
    return 0
  else
    >&2 echo "Something went wrong. Aborting..."
    git rebase --abort
    return 1
  fi
  # this is a not a good way.....
  # FILTER_BRANCH_SQUELCH_WARNING=1 git filter-branch -f \
  #   --msg-filter 'cat | __git-pair-new-commit-message "Co-authored-by: test"' \
  #   HEAD~1..HEAD
}

# XXX - could probably just alias this and use the previous function
git-pair() {
  local pair_alias
  local pair
  local prev_message
  local new_message

  if [ $# -eq 0 ]; then
    echo "Usage: git-pair <alias>"
    return 1
  else
    pair_alias="${1}"
  fi

  pair=$(
    command grep "${pair_alias}" "${HOME}/.git-pair" \
    | cut -d" " -f2-
  )

  prev_message=$(git log --format=%B --max-count=1)
  new_message=$(__git-pair-message-generate "${pair}" "${prev_message}")

  if [ "$new_message" != "$prev_message" ]; then
    git commit --amend --message "$new_message" --quiet
    echo "🍐'd with ${pair}"
  else
    echo "Already 🍐'd with ${pair}"
  fi
}

_git_pair_completion() {
  ## XXX - stop completion if it's not in a repo
  local options
  local word="${2}"
  ## XXX - have a look how to populate this with
  ## git shortlog -sne | cut -f2- | awk '{print $0}'
  options=$(awk '{print $1}' "${HOME}/.git-pair" | command grep -v "^#")
  COMPREPLY=($(compgen -W "${options}" -- ${word}))
}

complete -F _git_pair_completion git-pair
complete -F _git_pair_completion git-pair-all
