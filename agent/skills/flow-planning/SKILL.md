---
name: flow-planning
description: Use after material WHAT/WHY is settled when consequential implementation HOW should be made decision-complete before coding; write an execution-grade plan that moves judgment up front so constrained executors can work cheaply and escalate contradictions instead of improvising.
---

# Flow planning

Flow planning converts an approved contract/specification into an **execution-grade plan**. The goal is decision completeness, not document volume: pay for consequential engineering judgment once, encode it durably, then make implementation mostly plan-following.

Use this skill when the implementer would otherwise need to decide material file/module ownership, interfaces, state/data flow, error semantics, compatibility behavior, test shape, performance/lifetime constraints, or integration sequencing. Skip it for a tiny/bounded change whose implementation is already obvious from the contract and repository pattern.

## 1. Establish the planning boundary

Read the governing request/spec/unit contract, current source seams, tests, project rules, branch/worktree state and any validated external planning handoff. Planning does not carry implementation authorization.

For LDD, write under `.flow/ldd/<epic>/units/<unit>/`:

```text
PLAN.md
plan-tasks/
  01-<task>.md
  02-<task>.md
  ...
```

For non-LDD work, prefer `.flow/plans/<slug>/PLAN.md` plus `plan-tasks/` when the plan must survive compaction/session changes. A compact one-file plan is fine when it stays readable and no worker needs a sliced brief.

Record the source revision/dirty-state assumptions the plan was derived from. A revision change triggers targeted revalidation, not ritual replanning.

## 2. Front-load consequential judgment

An execution-grade plan settles, where applicable:

- exact files/modules and their responsibilities;
- task dependency/order and independently verifiable boundaries;
- interfaces/signatures/data ownership/state flow;
- error, edge, async/concurrency and compatibility semantics;
- concrete behavioral tests and expected Red/Green evidence;
- integration points and migration/serialization concerns;
- performance/allocation/lifetime constraints when material;
- explicit non-goals and forbidden scope expansion.

Use exact symbols, file paths and repository-native commands. Include code/pseudocode only where an exact recipe prevents rediscovery; do not make line count a goal or paste large code merely to appear complete.

A task is right-sized when it owns one coherent behavioral/test cycle and is worth one implementation boundary. Do not create a fresh task for setup or one-line propagation that belongs to a neighboring deliverable.

## 3. Define executor discretion

Every implementation task states four boundaries:

```text
Locked decisions:
- behavior/interfaces/ownership that must not drift

Executor discretion:
- inconsequential local choices the worker may make without escalation

Proof:
- failing/behavioral proof, focused checks, formatter/static checks

Escalate when:
- repository reality contradicts the plan
- a required interface/test cannot work as specified
- following the plan would knowingly introduce a defect
- scope/data/architecture/error semantics must change
```

The executor is allowed to recognize a bad plan. It is not allowed to silently redesign it.

## 4. Plan quality gate — move review left

Before the plan becomes execution-grade, inspect it through the normal review concerns. This is one integrated planning gate, not four automatic reviewer dispatches.

- **COR** — invariants, ownership, edge/error paths, integration and consequential failure modes are decided.
- **TTC** — changed behavior maps to named tests/proofs, including negative/boundary/compatibility cases where applicable; expected Red evidence is stated.
- **CRF** — responsibilities/decomposition are coherent; avoid planned dead abstractions, needless indirection, duplication, pathological lifetime/allocation behavior and mixed responsibilities.
- **SEC** — record run/skip with reason; when applicable, security boundaries and abuse/error behavior are explicit in the plan.

Challenge the plan itself. Plan compliance is not correctness: if a planned instruction would create a defect, repair the plan rather than teaching later reviewers to defend it.

The plan must end with a compact `Plan quality gate` receipt giving COR/TTC/CRF/SEC dispositions and any residual risks deliberately left to implementation evidence.

## 5. Mark execution grade

A plan is `execution-grade` only when:

- no consequential implementation choice is silently delegated to the executor;
- task interfaces agree across producer/consumer boundaries;
- each task has concrete proof and escalation conditions;
- placeholders such as TODO/TBD/"handle edge cases" are gone;
- source assumptions are current enough for the planned surfaces;
- the integrated plan quality gate passes.

If these do not hold, keep the artifact as strategy/draft and route unresolved judgment through planning/design rather than pretending it is cheap execution work.

## 6. Execution handoff

Main/controller validates the plan receipt and obtains/retains the normal implementation authorization boundary. Then `flow-execution` chooses:

- current execution-grade plan → `flow-plan-executor` (`@execute`) for the constrained implementation lane;
- task/plan contradiction or deliberately unresolved semantic judgment → `flow-implementer` (`@task`) or return to planning/design;
- exact mechanical leaf → `sonic` (`@smol`).

Prefer handing workers artifact paths instead of pasting whole plans into prompts. A sequential unit may keep one non-isolated plan executor alive across adjacent plan tasks to avoid cold-start/resident-context cost; independent tasks may use separate executors when concurrency is actually useful.

## External handoffs

A validated ChatGPT/other-harness bundle may already contain an execution-grade plan. Judge it against this contract. If it passes and source assumptions remain current, preserve it and do not repeat planning. If it contains a good strategy but not an execution-grade plan, keep the settled strategy and refine only the missing HOW; do not reopen settled WHAT/WHY.
