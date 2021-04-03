#!/usr/bin/env bash

case "${1}" in
  */COMMIT_EDITMSG)
    commit_message_file="${1}"

    new_co_author="Co-authored-by: ${PAIR}"
    prev_message="$(command grep -v '^#' "${commit_message_file}")"

    if [ -z "${prev_message}" ]; then
      >&2 echo "Err: Requires old commit message."
      exit 1
    fi;

    co_authors=$(
      echo "$prev_message" \
      | command grep "^Co-authored-by: " \
      | cat - <(echo "$new_co_author") \
      | LC_ALL=c sort -u
    )

    prev_message_without_co_authors=$(
      echo "$prev_message" \
      | command grep -v "^Co-authored-by: "
    )

    echo "${prev_message_without_co_authors}"$'\n\n'"${co_authors}" > "${commit_message_file}"
    exit 0;;
esac

# exit error
exit 1
