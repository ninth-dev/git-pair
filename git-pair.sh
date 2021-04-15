# XXX - should use bash scripts instead of functions ??
# con: need to put script into PATH
# pro: more portable
# pro: no need to do crazy things like the line below
__GIT_PAIR_HOME="$(dirname "${BASH_SOURCE[0]:-${(%):-%x}}")"

### XXX - should refactor ?
### maybe should just sit in the main function git-pair-from-commit-sha
### this is assigning the "pair" variable from where it was invoked
### functions in shells are made to just return exit codes
__git-pair-parse-pair() {
  local pair_alias
  if [[ -z "${1}" ]]; then
    >&2 echo "Error: missing argument"
    return 1
  else
    pair_alias="${1}"
  fi

  pair=$(
    command grep "${pair_alias}" "${HOME}/.git-pair" \
    | cut -d" " -f2-
  )

  # validate that the pair exists
  if [[ -z "$pair" ]]; then
    return 1
  else
    return 0
  fi
}

# XXX - wishlist
# - take a unlimited number of pairs
# - ability to reword specific commits only
# (commit-sha, pair) -> ()
__git-pair-from-commit-sha() {
  local pair
  local commit_sha
  local current_head

  commit_sha="${1}"

  if ! git rev-parse --git-dir > /dev/null 2>&1; then
    >&2 echo "Error: Not git directory."
    return 1
  fi

  if ! __git-pair-parse-pair "${2}"; then
    >&2 echo "\"${2}\" not found."
    return 1
  fi

  current_head="$(git rev-parse --short HEAD)"

  echo '---------------'
  echo 'To revert:'
  echo "  \$ git reset --hard ${current_head}"
  echo '---------------'

  if
    PAIR="${pair}" \
    GIT_EDITOR="${__GIT_PAIR_HOME}/editor.sh" \
    GIT_SEQUENCE_EDITOR="sed -i -e 's/pick/reword/g'" \
    git rebase \
      --autostash \
      --interactive \
      --committer-date-is-author-date \
      --quiet "${commit_sha}"~1;
  then
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

alias git-pair='__git-pair-from-commit-sha "HEAD"'
alias git-pair-unmerged="__git-pair-from-commit-sha \"\$(git cherry master --abbrev | awk '{print \$2}' | head -n 1)\""
alias git-pair-from='__git-pair-from-commit-sha'

_git_pair_completion() {
  local options
  local word="${2}"

  ## XXX - should look into zsh only completion
  if ! git rev-parse --git-dir > /dev/null 2>&1; then
    COMPREPLY=()
    return 0
  fi

  case "${COMP_CWORD}" in
    1)
      # get the last 10 commits abbrev hash
      options=$(git log --format="%h")
      COMPREPLY=($(compgen -W "${options}" -- ${word}))
      ;;
    2)
      ## XXX - have a look how to populate this with
      ## git shortlog -sne | cut -f2- | awk '{print $0}'
      options=$(awk '{print $1}' "${HOME}/.git-pair" | command grep -v "^#")
      COMPREPLY=($(compgen -W "${options}" -- ${word}))
      ;;
    *)
      ## default case
      ## XXX - maybe support multiple pairs later
      ;;
  esac
}

complete -F _git_pair_completion __git-pair-from-commit-sha
