# Forge detection and authentication

Shared by the pull request reviewing and receiving workflows. Run these from the
base repository.

```bash
remote_url=$(git remote get-url origin)
```

- `github.com` uses `gh`. Run `gh auth status` and obtain the account with
  `gh api user --jq .login`.
- `git.fiatcode.dev` uses `tea`. Confirm its login with
  `tea login list --output json` and obtain the account with
  `tea api /user | jq -r .login`.
- A missing, unsupported, or ambiguous remote stops the workflow.

The API helpers use stored credentials. Never read, print, or copy a token into
a command.

Verified against GitHub CLI 2.92.0 and `tea` 0.14.1 on 2026-08-22.
