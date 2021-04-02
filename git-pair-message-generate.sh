__git-pair-message-generate() {
  local prev_message
  local prev_message_without_co_authors
  local new_co_author
  local co_authors
  local stdin

  new_co_author="Co-authored-by: ${1}"
  shift
  ## XXX - probably can remove reading from stdin
  ## check if the input was from user, else `cat` the input (pipe-in)
  stdin="$([[ -t 0 ]] || cat)"
  prev_message="${stdin:-${1}}"
  ## if there was no input
  if [ -z "${prev_message}" ]; then
    >&2 echo "Err: Requires old commit message."
    return 1
  fi;

  prev_message_without_co_authors=$(
    echo "$prev_message" \
    | grep -v "Co-authored-by: "
  )

  co_authors=$(
    echo "$prev_message" \
    | command grep "Co-authored-by: " \
    | cat - <(echo "$new_co_author") \
    | LC_ALL=c sort -u
  )

  prev_message_without_co_authors=$(
    echo "$prev_message" \
    | command grep -v "Co-authored-by: "
  )

  echo "${prev_message_without_co_authors}"$'\n\n'"${co_authors}"
}
