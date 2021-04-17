# git-pair 🍐

`git-pair` enables you to simply add your co-authors to your commits.
Acknowledge **everyone** that contributes to the commit.
See [example](https://github.com/ninth-dev/git-pair/commit/0ee2f1f2b47033363534d8fda8b25e13f538cd67) with many authors.

## Features

- Reword previous X commits by appending `Co-authored-by: ..` in commit message
  - See [here](https://help.github.com/en/github/committing-changes-to-your-project/creating-a-commit-with-multiple-authors#creating-co-authored-commits-on-the-command-line)
- Autocompletion `git-pair <TAB><TAB>`
- Multiple Co-authors
- Idempotent
  - Co-authors will be unique and sorted alphabetically
- No dependencies other than `git` itself

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
    # For ZSH users, if the auto-completion is not working.
    # Try uncomment the following two lines:
    # autoload -Uz compinit && compinit
    # autoload -Uz bashcompinit && bashcompinit
    source <PATH_TO_GIT_PAIR>/git-pair.sh
    ```

4. Restart your shell or source your startup file.

## Getting Started

After committing and you want to add your pair (co-author) in.

```sh
$ git commit --message "nit: some random bugfix"
$ git-pair john-smith
---------------
To undo:
  $ git reset 1f49b92
---------------
[detached HEAD fc29653] refactor
 Date: Thu Apr 1 22:00:36 2021 +1100
 1 file changed, 2 insertions(+)
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
---------------
To undo:
  $ git reset fc29653
---------------
[detached HEAD 2b2e1d4] refactor
 Date: Thu Apr 1 22:00:36 2021 +1100
 1 file changed, 2 insertions(+)
🍐'd with Jane Doe <jane.doe@example.com>

$ git log -1
.
.
Co-authored-by: Jane Doe <jane.doe@example.com>
Co-authored-by: John Smith <john.smith@example.com>
```

## Basic Usage

Since `v2`, `git-pair` is powered with aliases. The following aliases are added from the installation:

- `git-pair`: amend the previous commit

   e.g. `$ git-pair ninth-dev`

- `git-pair-rebase-main`: amend the previous X commits that have not been merged to the local master/main branch yet.

    e.g. `$ git-pair-rebase-main ninth-dev`

- `git-pair-rebase`: rebase from a specifc commit hash (inclusive)

    e.g. `$ git-pair-rebase 1e518f ninth-dev`

## History

`git-pair` initially used `git commit --amend` to amend the previous commit message. However, it became problematic when doing several small commits and forgetting to run `git-pair`. The desire to be able to amend more than one commit message was born. In order to achieve this, it was migrated to use `git rebase --interactive` in `v2`.


