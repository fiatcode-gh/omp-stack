---
name: flow-execution
description: Use when local implementation is authorized for a bounded change or approved OMP plan; route work by judgment, preserve useful unit owners, delegate mechanical leaves cheaply, verify by ownership and review proportionally before integration.
---

# Flow execution

OMP owns plan approval, task spawning, isolation and Agent Hub. This skill owns execution judgment. The same execution model applies inside and outside LDD.

## 1. Orient

Read the governing request/spec/approved plan and project rules. Inspect branch/worktree and dirty state. Identify the **dependency graph**, not just a task list.

Classify units:

- independent against the same base → may run concurrently;
- dependent on another unit's result/interface → serialize or start from the verified updated base;
- overlapping mutable surface → one writer at a time unless the units are explicitly redesigned to be independent.

Separate unresolved **judgment** from settled/mechanical work. A detailed plan reduces rediscovery; it does not make every implementation mechanical.

## 2. Route by work type

Use the cheapest owner that can correctly own the remaining judgment:

- tiny cohesive edit where spawn overhead exceeds the work → Main may implement directly under `flow-tdd`;
- bounded read-only fact finding → bundled `scout`;
- fully specified **behavior-preserving** mechanical edit, or an already-diagnosed exact correction with an existing failing/mechanical proof and one obvious result → bundled `sonic` may be dispatched directly;
- new executable behavior, TDD sequencing, semantic implementation, debugging, integration or work that still requires judgment → `flow-implementer` (`@task` / Terra owner).

Do not route ambiguous/new behavior, architecture, migration semantics, concurrency/error semantics or root-cause diagnosis to `sonic` merely because a plan exists. Direct Sonic must not bypass Red/Green: when executable behavior is changing, Main/Terra owns the TDD cycle and may delegate only settled leaves within it.

A `flow-implementer` may itself use `scout` for bounded discovery and `sonic` for settled mechanical leaves. Nested delegation is optional and must not create overlapping writers or transfer design/integration responsibility to the child.

## 3. Preserve the unit owner

For a sole/sequential implementation unit on a suitable feature checkout, prefer a **non-isolated** `flow-implementer`. This keeps its context/session available for clarification, verification follow-up and review corrections.

Use task isolation for independent concurrent writers or an explicitly disposable experiment. Do not isolate by reflex: a completed isolated task is intentionally disposable and may not be revivable after its workspace is applied/cleaned.

Keep the unit owner's agent id/name. When later evidence finds a semantic correction, follow up with that same non-isolated owner through `hub` when available instead of cold-spawning another Terra worker.

## 4. Write a verification-capable brief

Worker briefs are self-contained: intended behavior, exact scope/subsystem, governing constraints/interfaces, observable acceptance criteria, workspace/concurrency context and verification scope. Do not paste the whole conversation. Do not pass concrete model names.

Never broadly tell a writer "do not test/build/format because Main will verify." Instead:

- require focused repository-native proof of the writer's own changes;
- make touched-file formatting the writer's responsibility when the repository's canonical formatter can be scoped safely to those files; do not reserve ordinary touched-file formatting for Main;
- allow focused lint/type/build checks owned by the writer's surface;
- explicitly authorize broader/project-wide gates when the worker is the sole writer or otherwise isolated from sibling in-progress edits;
- reserve repo-wide autoformatting and final cross-unit/full-repository acceptance for Main when those commands could rewrite/check sibling-owned or unrelated work.

## 5. Clarify live

Workers should not terminally fail at the first real ambiguity. They first derive what they can from the contract, repository, tests and tools. When the unresolved point would change/extend approved behavior, scope, interface, data contract or architecture, the `flow-implementer` asks Main through `hub` with concise evidence + recommendation and continues any independent work. It awaits only when completely blocked.

Main may clarify within the already-approved contract. Main must not silently expand authorization. If the answer requires a new product/design/user choice or proves the governing plan wrong, tell the worker to stop at a clean boundary and return BLOCKED, then route through design/Plan/user decision.

When Main has useful independent work, do it while children run. When Main is otherwise blocked on a child completion or reply, wait **eventfully rather than polling**: use one bounded `hub` wait over the relevant task job ids when available, with a window long enough for the expected work (commonly 15–30 minutes for a semantic unit), or use `hub send` with `await: true` / a peer-filtered wait when the next useful event is one specific child's reply. Do not burn turns on repeated 3–5 minute status polls. Do not use an unbounded wait by default; if a long bounded wait expires, inspect liveness/current state before deciding whether to wait again or intervene.

## 6. Accept by layered evidence

For each completed unit/wave:

1. inspect the actual patch/files, not only worker prose;
2. inspect material nested-child changes as part of the owning unit;
3. confirm the worker ran focused proof appropriate to its changed surface;
4. independently verify the **consequential claim or integration boundary**, not necessarily the exact same full suite again;
5. check integration points with already accepted work;
6. reject/correct deviations before dependent work proceeds.

A child proves its leaf; the Terra owner proves the combined unit; Main proves integration/high-risk claims and owns final repository acceptance. Delegation never transfers verification responsibility, but independent evidence does not require ritual duplicate full-suite runs.

## 7. Route corrections cheaply

When verification/review finds a problem:

- exact, fully diagnosed mechanical correction with an existing failing/mechanical proof and one obvious result → direct `sonic` is appropriate;
- correction needing semantic context/judgment → message/revive the existing `flow-implementer` owner when available;
- owner unavailable/non-revivable → dispatch a new bounded `flow-implementer` as fallback;
- correction invalidates the governing contract/plan → stop implementation and return through design/Plan/user decision.

After a correction, rerun the proof affected by that edit plus any integration/final gates made stale. Do not restart the entire workflow by ritual.

## 8. Review proportionally

Do not pay for a full specialist round after every tiny task. Review **coherent waves**, high-risk units immediately, and the whole change before integration.

- Correctness: OMP bundled `reviewer` (normal strong review).
- TTC: `flow-ttc-reviewer` when behavior/tests/validation/migrations/types/schemas/contracts changed.
- Craft: `flow-craft-reviewer` for non-trivial logic, abstractions, docs/comments, cross-module refactors, duplication/nesting or mixed responsibilities.
- Security: built-in `security-reviewer` or native `security_scan` when the change crosses a meaningful security boundary.

Before dispatch, record an explicit disposition for **COR / TTC / CRF / SEC**: run or skip, with one short reason grounded in the actual changed surface. COR is always run for an initial coherent change review. Conditional lenses must not disappear by silent omission; the disposition can be concise and need not become user-facing ceremony.

Run applicable read-only lenses in parallel and blind to one another. Verify Critical/Important findings before acting on them. After fixes, rerun only the lens(es) whose findings or newly changed risk surface require independent re-review; a complete review round is not automatic. Avoid endless review/fix loops; repeated disagreement/failure becomes an evidence-backed user decision/escalation.

## 9. Close execution

When the governing plan/user expects local commits, commit coherent behavior units rather than one mechanical task per commit by ritual; use Conventional Commits and the repository's pre-commit checks. Do not create commits merely because an internal worker boundary existed.

Run or reuse fresh Main-owned final verification only while the final tree/head is unchanged and the evidence covers the final claims. Inspect the final diff. Then use `flow-integrating` for the user's integration choice.
