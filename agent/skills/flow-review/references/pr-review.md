# PR reviewer mode

Review an existing GitHub/Forgejo pull request. Never modify the contributor branch.

1. Pin exact remote base/head, description/requirements, commits, changed files/stat, required checks and existing discussion. For re-review, identify the last reviewed commit/verdict and verify old findings against the new head before focusing on the delta plus affected callers/contracts.
2. Build a metadata-only packet; specialists fetch their own diff/context.
3. Select COR/TTC/CRF/SEC by `review-lenses.md` and fan out applicable read-only specialists in parallel.
4. Verify/synthesize findings. A failing required check is blocking; unavailable/ambiguous required-check evidence is comment-only.
5. Verdict: verified Critical/Important → request changes; no blockers + required checks green → approve; incomplete/pending/conflicted evidence → comment.
6. Draft one concise summary and only valuable changed-line inline comments. Show exact action/text/inline set to the user.
7. After approval, re-query head. Head moved → publish nothing and rebuild. Use the forge's batched review mechanism when available. Partial write → report exactly what posted; never retry blindly.

For Forgejo mechanics use `references/forge-operations.md` and the collector script. GitHub retrieval/publication should prefer OMP's available GitHub/PR surfaces.
