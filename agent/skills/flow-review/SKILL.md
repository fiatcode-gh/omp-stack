---
name: flow-review
description: Use for reviewing a local change or existing GitHub/Forgejo pull request, handling feedback on the user's own PR, or auditing a codebase/area; selects independent evidence-backed review lenses and protects forge publication with explicit approval.
---

# Flow review

One review doctrine, four modes. Determine the mode first and load its reference when needed:

- **Local/change review** — inspect current/explicit diff; no forge publication.
- **PR reviewer** — existing PR; read-only contributor branch; `references/pr-review.md`.
- **Author feedback** — feedback on the user's own PR; re-anchor/triage/fix/reply; `references/author-feedback.md`.
- **Codebase audit** — repository/area at rest; `references/audit.md`.

`references/review-lenses.md` is the standard of record for change reviews. `references/audit-lenses.md` defines whole-tree audit lenses.

## Shared evidence contract

Specialist reports are claims. Verify every Critical/Important finding by reading cited/surrounding code and using targeted diagnostics/tests when they add proof. Cheaply verify Minor findings; label or omit unverified leftovers. Merge duplicate root causes and investigate conflicts instead of voting.

Never expose secret values. Review/audit specialists are read-only.

## Change-lens selection

- COR always.
- TTC only when executable behavior/tests/validation/migrations/types/schemas/contracts changed.
- CRF only when non-trivial logic, abstractions, docs/comments, cross-module refactors, duplication/nesting or mixed responsibilities changed.
- SEC only when a real security boundary is involved (authentication/authorization, secrets, cryptography, payments, destructive operations, untrusted-input boundaries, privileged filesystem/process/network access, etc.).

Route COR to bundled `reviewer`; TTC to `flow-ttc-reviewer`; CRF to `flow-craft-reviewer`; SEC to built-in `security-reviewer` or native `security_scan` when a dedicated scan is warranted. Do not pass concrete model names.

Run applicable lenses in parallel and blind to one another.

## Publication gate

Any forge write — review verdict/comment, reply, resolve action, reviewer request — requires the user's approval of the **exact** draft/action set. Re-query remote head immediately before publishing; if it moved, post nothing until the draft is rebuilt against the new head.
