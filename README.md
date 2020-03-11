# git-pair

A simple script to amend the previous commit with a co-author.

## Installation

1. Add into your shell startup file (e.g. `.zshrc`, `.bashrc`)

```sh
source <PATH_TO_GIT_PAIR>/git-pair.sh
```

2. Create an file `$HOME/.git-pair` and add your team mates.

```sh
# Following the pattern: alias name <email>
(
echo "john-smith John Smith <john.smith@example.com>"
echo "jane-doe John Smith <john.smith@example.com>"
) > $HOME/.git-pair
```
NB: You can just open the file and edit it yourself :)

3. Restart your shell or source your startup file.

## Getting Started

After committing normally and you want to add your pair in.

```sh
$ git commit --message "nit: some random bugfix"
$ git-pair john-smith
```

This will amend the previous commit message and append `John Smith` as a co-author.
