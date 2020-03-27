# git-pair 🍐

`git-pair` is a bash script that enables you to simply add your co-authors to your commits.

Acknowledge **everyone** that contributes to the commit.

## Features
- Amend previous commit message by appending `Co-authored-by: ..`
  - See [here](https://help.github.com/en/github/committing-changes-to-your-project/creating-a-commit-with-multiple-authors#creating-co-authored-commits-on-the-command-line)
- Autocompletion `git-pair <TAB><TAB>`
- Multiple Co-authors
- Idempotent
  - Co-authors will be unqiue and sorted alphabetically

## Installation

1. Clone the repo

```sh
git clone https://github.com/ninth-dev/git-pair.git
```

2. Create an file `$HOME/.git-pair` and add your team mates

e.g.

```sh
# Follow the pattern: alias name <email>
(
echo "john-smith John Smith <john.smith@example.com>"
echo "jane-doe Jane Doe <jane.doe@example.com>"
echo "alice Alice <alice@example.com>"
echo "bob Bob <bob@example.com>"
) > $HOME/.git-pair
```

**NB:** You can just open the file `$HOME/.git-pair` and use your favourite editor :)

3. Source the `git-pair` script to your shell startup file (e.g. `.zshrc`, `.bashrc`)

```sh
source <PATH_TO_GIT_PAIR>/git-pair.sh
```

4. Restart your shell or source your startup file.

## Getting Started

After committing and you want to add your pair (co-author) in.

```sh
$ git commit --message "nit: some random bugfix"
$ git-pair john-smith
🍐'd with John Smith <john.smith@example.com>
```

This will amend the previous commit message :

```sh
$ git log -1
.
.
Co-authored-by: John Smith <john.smith@example.com>
```

## Want to add another pair?

```sh
$ git-pair jane-doe
🍐'd with Jane Doe <jane.doe@example.com>
$ git log -1
.
.
Co-authored-by: Jane Doe <jane.doe@example.com>
Co-authored-by: John Smith <john.smith@example.com>
```

## Mob programming?

You could also simply just create an alias for your mob-programming sessions.

```sh
alias git-mob='git-pair john-smith && git-pair jane-doe && git-pair alice && git-pair bob'
```

```sh
$ git-mob
🍐'd with John Smith <john.smith@example.com>
🍐'd with Jane Doe <jane.doe@example.com>
🍐'd with Alice <alice@example.com>
🍐'd with Bob <bob@example.com>

$ git log -1
.
.
Co-authored-by: Alice <alice@example.com>
Co-authored-by: Bob <bob@example.com>
Co-authored-by: Jane Doe <jane.doe@example.com>
Co-authored-by: John Smith <john.smith@example.com>

# NB: Co-authors are sorted alphabetically
```
