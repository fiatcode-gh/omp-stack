# `tea` cookbook — git.fiatcode.dev daily driver

All commands assume you are inside a cloned `git.fiatcode.dev` repo (so `tea`
discovers the login + repo from the remote). Otherwise add `--repo <owner>/<repo>`.

## Pull requests

```bash
# List open PRs for the current repo
tea pr
tea pr list --state open --output json     # scriptable

# Read PR #42 — shows CI status + review summary
tea pr 42

# Create a PR off the current branch into the default base
tea pr create --title "feat: add X" --description "Closes #12"
# Explicit base/head, labels, assignees
tea pr create --base main --head feature/x --title "..." \
  --labels enhancement --assignees fiatcode

# Check out PR #42 locally (no fork needed); -b makes a local branch
tea pr co 42
tea pr co 42 -b

# Review actions
tea pr approve 42
tea pr reject 42                 # request changes
tea pr review 42                 # interactive terminal review

# Merge (styles: merge, rebase, squash, rebase-merge)
tea pr merge 42 -s squash
tea pr merge 42 -s rebase -t "feat: add X"

# Review comments on a PR
tea pr review-comments 42
tea pr resolve <comment-id>
tea pr unresolve <comment-id>
```

## What needs my attention

```bash
tea notifications --mine
tea notifications --mine -o simple        # terse, one per line
```

## Issues

```bash
tea issue                                  # list open
tea issue 189                              # view #189
tea issue 189 --output json --comments
tea issue create --title "bug: ..." --description "..."
tea issue list --state closed --keyword login --labels bug --output json
```

## Releases (tag-driven, e.g. signed AABs)

```bash
tea release list
# From an existing tag
tea release create v1.2.0 --title "Release v1.2.0" --note "..."
# With notes file + assets
tea release create --tag v1.3.0 --target main --title "v1.3.0" \
  --note-file ./CHANGELOG.md --asset ./dist/app-arm64
```

## Login management (rarely needed after first seed)

```bash
tea logins                       # list configured instances
tea login default fiatcode       # set default
```
