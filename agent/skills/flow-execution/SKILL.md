---
name: flow-execution
description: Use when local implementation is authorized for a bounded change or approved OMP plan; execute by dependency waves, isolate independent writers, apply TDD, review proportionally and verify before integration.
---

# Flow execution

OMP owns plan approval, task spawning, isolation and Agent Hub. This skill owns execution discipline.

## 1. Orient

Read the governing request/spec/approved plan and project rules. Inspect branch/worktree and dirty state. Identify the **dependency graph**, not just a task list.

Classify units:

- independent against the same base → may run concurrently;
- dependent on another unit's result/interface → serialize or start from the verified updated base;
- overlapping mutable surface → one writer at a time unless the units are explicitly redesigned to be independent.

## 2. Choose execution shape

- Small cohesive work: the main session may implement directly under `flow-tdd`.
- Larger/bounded work: dispatch `flow-implementer` units.
- Concurrent independent writers: use OMP `task` isolation when available.
- Do not isolate by reflex. Isolation follows independence; unnecessary isolation creates patch/integration overhead.

Worker briefs are self-contained: intended behavior, exact scope/subsystem, governing constraints/interfaces and observable acceptance criteria. Do not paste the whole conversation. Do not pass concrete model names.

If a worker discovers a new product/design choice or proves the governing plan wrong, stop that unit and return to design/Plan/user decision rather than improvising.

## 3. Accept by evidence

For each completed unit/wave:

1. inspect the actual patch/files, not only worker prose;
2. run focused proof appropriate to the unit;
3. check integration points with already accepted work;
4. reject or correct deviations before dependent work proceeds.

## 4. Review proportionally

Do not pay for a full specialist round after every tiny task. Review **coherent waves**, high-risk units immediately, and the whole change before integration.

- Correctness: OMP bundled `reviewer` (normal strong review).
- TTC: `flow-ttc-reviewer` when behavior/tests/validation/migrations/types/schemas/contracts changed.
- Craft: `flow-craft-reviewer` for non-trivial logic, abstractions, docs/comments, cross-module refactors, duplication/nesting or mixed responsibilities.
- Security: built-in `security-reviewer` or native `security_scan` when the change crosses a meaningful security boundary.

Run applicable read-only lenses in parallel and blind to one another. Verify Critical/Important findings before acting on them. Avoid endless review/fix loops; repeated disagreement/failure becomes an evidence-backed user decision/escalation.

## 5. Close execution

When the governing plan/user expects local commits, commit coherent behavior units rather than one mechanical task per commit by ritual; use Conventional Commits and the repository's pre-commit checks. Do not create commits merely because an internal worker boundary existed.

Run fresh final verification and inspect the final diff. Then use `flow-integrating` for the user's integration choice.
