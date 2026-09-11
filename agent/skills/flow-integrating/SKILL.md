---
name: flow-integrating
description: Use when implementation is locally complete and the user must decide how to integrate it; require fresh final evidence, reconcile scope, assess reviewability, then present merge/PR/keep/split choices without acting remotely first.
---

# Flow integrating

Integration belongs to the user.

## 1. Prove local completion

Run the appropriate fresh final test/build/lint/format/static checks and inspect the final diff/status. Re-test the original symptom for bug fixes. State pre-existing/unverified failures separately.

Reconcile the result against the governing request/spec/approved plan. Name omissions/deviations rather than silently redefining done.

## 2. Assess cohesion/reviewability

Judge whether the change is one coherent review unit. Changed-line count is evidence, not a threshold. Suggest splitting only when there are independently valuable concerns, unrelated risk domains, or a review would be materially clearer as separate changes.

## 3. Ask for the integration decision

Present only choices that are actually available, for example:

- merge locally;
- push/open or update a pull request;
- keep the branch/worktree for later;
- split into coherent units first.

Do not push, open/update a PR, request reviewers, merge or release until the user chooses the exact action.

## 4. After integration

Re-check actual remote/local result before claiming integration succeeded. Delete a local feature branch only when it is genuinely integrated and safe. For a user-owned external worktree, report it as removable; do not remove it yourself unless explicitly instructed.
