# Forge operations for Flow PR review

Use current forge metadata as the source of truth. Never publish a verdict against a stale head.

## GitHub on OMP

Prefer OMP-native reads:

- `pr://<number>` / repo-qualified PR URLs for metadata, comments, and review context;
- `pr://<number>/diff`, `/diff/<i>`, or `/diff/all` for changed files/diff;
- OMP's `github` tool for repo/file/search/checkouts when enabled;
- the bundled `reviewer` can inspect `gh pr diff <number>` read-only when `gh` is available.

When local execution against the PR head is required, prefer OMP's GitHub `pr_checkout` operation rather than hand-rolling a user worktree. Verify the checked-out head still equals fresh forge metadata before relying on results.

OMP's current GitHub tool does not expose a submit-review operation. After the user approves the exact review draft, use `gh api` to submit the batched review. Do not confuse native read/check-out support with publication permission.

## Forgejo (`git.fiatcode.dev`)

Use `tea` with stored credentials. The helper beside this reference, `../scripts/collect-forgejo-context.sh`, collects PR metadata/reviews/files/status into a packet directory. A non-zero helper exit means the packet is incomplete; do not guess around it.

If local execution is necessary, use a dedicated clean checkout/worktree at the exact remote head. Never hard-reset the user's active working checkout. Verify `HEAD` equals the forge-reported head before reading/testing code.

## Publication safety

Immediately before publication, query the remote head again. If it moved, post nothing; rebuild the draft against the new head.

Submit one review transaction where the forge supports it. GitHub:

```bash
gh api -X POST "repos/$base_repo/pulls/$number/reviews" --input "$payload_file"
```

Forgejo:

```bash
tea api -X POST "/repos/{owner}/{repo}/pulls/$number/reviews" --data "@$payload_file"
```

Use only the detected forge. Validate inline anchors against the current diff before submission. If a call may have partially written anything, report exactly what is known to have posted and never retry blindly.

The authenticated PR author cannot issue a formal approve/request-changes verdict on their own PR; use comment in that case.
