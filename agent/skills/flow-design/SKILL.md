---
name: flow-design
description: Use when a requested change has a material product, architecture, interface, data-flow or user-experience decision that should be resolved before implementation; not for mechanical edits or already-decided work.
---

# Flow design

Resolve **what/why** decisions before implementation. Native OMP Plan mode owns the later **how-to-execute** specification.

## When this is warranted

Use this skill when at least one real fork affects behavior, architecture, interfaces, persistence/data ownership, failure semantics or user experience. A typo, dependency bump, obvious one-file bug after root cause, or already-approved specification does not need manufactured design ceremony.

## Process

1. Explore the relevant project reality first: instructions, current implementation, tests/contracts and recent history. Use read-only scouts when breadth helps.
2. State your opinionated reading of the intent, important constraints and the material fork(s). Separate facts from assumptions.
3. Ask only questions whose answers change the design; handle one unresolved material fork at a time.
4. Offer alternatives only when genuinely viable alternatives exist. Name your recommendation and trade-offs.
5. Converge on the smallest design that satisfies the requirement. Cover only relevant surfaces: components/boundaries, data/control flow, errors, compatibility and test strategy.
6. Get explicit user agreement on product/architecture choices before code depends on them.
7. After each settled fork, maintain the forward pointer: move to the next unresolved material fork, or state the next downstream action (unit contract / Plan / execution) and whether another user decision is actually required. Do not make the user say "continue" when the design workflow already determines the next step.

## Imported design context

A validated external planning/LDD handoff may contain user-approved design decisions. Treat those as external evidence until current project/LDD authority is checked, then preserve still-valid settled decisions instead of re-running brainstorming by ritual. Reopen only decisions that are stale, contradicted, materially incomplete, or not actually user-approved. An implementation strategy in the handoff belongs to Plan/execution reasoning, not to this design skill.

## Durability

- Ordinary small decisions may live in the conversation.
- A durable standalone design may be written to `docs/specs/YYYY-MM-DD-<topic>-design.md` when the user/project benefits from it.
- Under `flow-ldd`, record the decision/specification in the epic's `.flow/ldd/<epic>/` authority instead of creating a parallel spec system.

## Rules

- No coding while an unresolved material design decision would make the implementation speculative.
- Do not force two/three fake options when one approach is clearly dictated by constraints.
- Do not turn implementation mechanics into architecture. Native Plan mode is the execution-planning layer.
- YAGNI applies to the design itself.
