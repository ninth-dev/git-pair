#!/usr/bin/env bash

source "${GIT_PAIR_MESSAGE_GENERATE}"

case "${1}" in
  */COMMIT_EDITMSG)
    commit_message_file="${1}"
    prev_message="$(cat "${commit_message_file}" | command grep -v '^#')"
    new_message=$(__git-pair-message-generate "${PAIR}" "$prev_message" | command grep -v '^#')
    tmp=$(mktemp -t gp-XXXXXXX)
    echo "$new_message" > "${tmp}"
    mv "${tmp}" "${commit_message_file}"
    exit 0
esac

# exit error
exit 1
