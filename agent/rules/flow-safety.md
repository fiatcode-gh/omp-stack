---
name: flow-safety
description: Always-on repository-state and external-effect safety rules.
alwaysApply: true
---

# Flow safety

Before mutating a repository, inspect the current branch/worktree and working-tree state.

- Treat pre-existing changes as user-owned. Never silently discard, reset, stash, overwrite, relocate, or "clean up" them.
- Do not put feature work directly on `main`/`master` unless the user explicitly chose that.
- One writer may use the current suitable checkout. Independent concurrent writers should use OMP isolation when available. Dependent writers stay sequential.
- Do not assume another agent/session's workspace is disposable or safe to mutate.
- User-owned external worktrees are never created, removed, force-switched, or repurposed without explicit instruction.
- Pushes, force-pushes, pull-request creation/update, review publication, reviewer requests, merges, releases, remote comments/messages, and other stakeholder-visible writes require explicit user approval for that action/round.
- A plan/execution approval authorizes the local code-writing needed to execute its agreed scope; it does not authorize external publication or integration.
- Never expose secrets in logs, reports, review comments, memory, or generated artifacts. Redact values; retain only the minimum location/type evidence needed.
