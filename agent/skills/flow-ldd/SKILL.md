---
name: flow-ldd
description: Use for multi-story or cross-repository epics that need a durable architect-owned decision ledger across many execution waves/sessions; LDD adds durable architecture control on top of the normal Flow execution model.
---

# Ledger-driven development (LDD)

LDD preserves a strict role split:

- **Architect/controller** owns intent, recon, decisions, specifications, unit boundaries, verification, integration sequencing and the ledger.
- **Workers** write production code using the normal `flow-execution` model.

While LDD is active, the architect **never writes production code**, including tiny corrective edits. It routes corrections through the existing unit owner or another bounded worker. This keeps the long-lived context about why/what, not implementation minutiae.

The durable authority lives under `.flow/ldd/<epic>/`. Do not use `.omp/` for LDD state; `.omp/` has configuration/discovery semantics.

## Authority boundary

The ledger owns durable **project truth**: accepted product/architecture decisions, contracts, traps, verified facts, unit state and unresolved questions.

The current Flow/OMP stack owns **execution mechanics**: agent transport, mailbox vs Hub, isolation/workspace policy, model routing, verification layering and task lifecycle. Historical ledger/handoff instructions about those mechanics are version-sensitive evidence, not permanent authority; revalidate them against the current stack when resuming. Static planning handoffs from ChatGPT/another harness are also evidence/proposals until reconciled into the current ledger. Explicit current user instructions outrank both.

## External planning intake

When the user brings a ChatGPT/other-harness planning bundle into an epic, first use the `flow-external-session` planning-handoff protocol. Validate its manifest, observed repository revision, local dirty state and current ledger. Do not copy a proposed ledger delta/unit into canonical state blindly; reconcile it, record accepted decisions/contracts, and preserve conflicts/open questions explicitly. A handoff does not carry local implementation authorization.

Do not make the user repeat already-settled design choices merely because they were decided in another session. Reopen only a fork whose assumptions are stale, contradicted, unapproved, or materially incomplete. Preserve a current external strategy even when it is not yet execution-grade. If the bundle's plan satisfies the current `flow-planning` execution-grade contract, do not repeat planning; otherwise refine only the missing consequential HOW/tests/interfaces instead of reopening settled WHAT/WHY.

## Loop

1. **Re-orient cheaply** — start with the current RESUME snapshot, active unit contract, active `PLAN.md`/current plan task when present, and git branch/status/diff. Read older ledger/history only when the resume pointer or a live contradiction requires it; do not rehydrate the whole epic by ritual. Agent Hub/history is execution evidence; the ledger is current project truth.
2. **Bootstrap** (new epic) — choose local vs shared ledger mode with the user and create `references/ledger-skeleton.md`.
3. **Recon** — verify inherited claims at source. For broad recon spanning separable subsystems/historical sources, prefer bounded parallel read-only `scout` tasks for extraction/mapping; the architect synthesizes centrally and independently checks consequential facts. Do not spawn scouts for trivial recon.
4. **Decide** — resolve product/architecture forks with the user. Use `flow-design` for a material decision. Lock the result in the ledger.
5. **Specify unit** — write the unit contract: behavior, boundaries, dependencies, acceptance criteria, traps and verification expectations. This is the WHAT/authority boundary, not an excuse to delegate consequential HOW to an implementer.
6. **Plan consequential HOW** — when the unit would otherwise require implementation judgment, use `flow-planning` / `flow-planner` to create an execution-grade `PLAN.md` + bounded task briefs. A tiny/obvious unit may skip this and stay on the semantic lane. A current validated external execution-grade plan may satisfy the stage; strategy-only handoffs retain their valid decisions and are refined only where needed.
7. **Authorize/dispatch** — a plan/handoff never carries local implementation authorization. Once authorized, use `flow-execution`: a sole/sequential execution-grade plan owner on a suitable feature checkout is normally non-isolated and uses `flow-plan-executor` (`@execute`); unresolved semantic/debugging work → `flow-implementer` (`@task`); exact mechanical leaves → `sonic`. Independent top-level writers may run isolated/concurrently. External top-level session/other harness → `flow-external-session`.
8. **Clarify/wait live** — plan executors escalate contradictions instead of redesigning; semantic owners resolve local uncertainty and ask Main only when the contract/design boundary moves. A genuinely new decision returns through `flow-planning`/`flow-design`/user approval. When fully blocked on a worker, follow `flow-execution`'s bounded event-driven Hub-wait policy rather than spending turns polling status.
9. **Verify/accept** — inspect actual patches and consequential integration evidence. For execution-grade planned work, use one strong `flow-acceptance-reviewer` after the coherent implementation rather than routine COR/TTC/CRF fan-out; it checks both plan conformance and independent correctness. Worker self-verification is required and architect verification remains additive.
10. **Correct efficiently** — verify/deduplicate material findings, batch them into one correction round, return in-plan fixes to the existing plan executor, semantic fixes to the semantic owner, and plan defects back through `flow-planning`. Use one scoped acceptance closure review by default rather than restarting all lenses.
11. **Record** — append decisions/results, status, verification receipts and a fresh RESUME snapshot that names the exact next plan task/action; preserve unresolved hazards/deviations.
12. **Integrate** — sequence accepted units; external publication/merge stays user-owned (`flow-integrating`).

## User-facing continuity

The architect maintains a **forward pointer** across sessions and checkpoints. After a recon result, locked decision, accepted unit, correction, or ledger update, briefly state what is now true, what the architect will do next, and whether the user must decide/approve anything. If the next step is determined by this loop and already authorized, proceed without asking the user to choose it. At a real approval/design/integration gate, ask the concrete question immediately instead of reporting status and stopping.

## Ledger boundary

The ledger is not a backlog and not a transcript. Weft remains the durable human/project backlog. The ledger holds only what a future architect needs to continue the epic correctly: current state, locked decisions/rejected alternatives, cross-unit contracts, traps, open questions, unit status, verification receipts and corrections to previous assumptions.

Worker transcripts/patches/PR discussions are evidence linked from the ledger, not copied wholesale into it.

## Coordination hierarchy

1. Same OMP session/task agents → Agent Hub/`hub`, `history://`, `agent://`.
2. Optional Vibe director mode when persistent worker conversations are specifically useful; remember it is a different session mode, not a requirement of LDD.
3. Independent top-level session/other harness → `flow-external-session` static planning/worker handoff; mailbox only when durable two-way asynchronous conversation is actually needed.

Never create a filesystem mailbox around ordinary OMP child agents.
