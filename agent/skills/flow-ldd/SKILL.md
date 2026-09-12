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

Do not make the user repeat already-settled design choices merely because they were decided in another session. Reopen only a fork whose assumptions are stale, contradicted, unapproved, or materially incomplete. Likewise, if the handoff contains a sufficiently detailed implementation strategy that remains current, do not spend a native Plan call just to restate it. Use native Plan only for the implementation strategy that is still materially unresolved/risky.

## Loop

1. **Re-orient** — current RESUME snapshot, epic status, decision tail, open questions, traps and in-flight unit state. Agent Hub/history is execution evidence; the ledger is current project truth.
2. **Bootstrap** (new epic) — choose local vs shared ledger mode with the user and create `references/ledger-skeleton.md`.
3. **Recon** — verify inherited claims at source. For broad recon spanning separable subsystems/historical sources, prefer bounded parallel read-only `scout` tasks for extraction/mapping; the architect synthesizes centrally and independently checks consequential facts. Do not spawn scouts for trivial recon.
4. **Decide** — resolve product/architecture forks with the user. Use `flow-design` for a material decision. Lock the result in the ledger.
5. **Specify unit** — write a fresh-worker-ready unit contract: behavior, boundaries, dependencies, acceptance criteria, traps and verification expectations. A hard story may use native Plan mode when its implementation strategy remains materially unresolved; a well-specified ordinary story or a current validated external implementation strategy need not spend a Plan call.
6. **Dispatch** — use `flow-execution` rather than inventing an LDD-specific worker protocol. A semantic unit normally has one Terra `flow-implementer` owner; it may use nested `scout` discovery and `sonic` mechanical leaves. A sole/sequential writer on a suitable feature checkout is normally non-isolated so it can be resumed for corrections. Independent top-level writers may run isolated/concurrently. External top-level session/other harness → `flow-external-session`.
7. **Clarify/wait live** — workers resolve local uncertainty themselves first. A unit owner may ask the architect/Main through `hub` when the remaining ambiguity would alter a locked behavior/scope/interface/data/architecture decision. The architect answers only inside already-authorized decisions; material clarifications/corrections are recorded in the ledger. A genuinely new decision returns through `flow-design`/user approval instead of being improvised. While workers run, the architect does useful independent architect work when available; when fully blocked, follow `flow-execution`'s bounded event-driven Hub-wait policy rather than spending turns polling status.
8. **Verify/accept** — inspect actual patches and independently verify consequential unit/integration claims using `references/verification-doctrine.md`. Worker self-verification is required; architect verification is additive, not a substitute for it. Child and unit-owner reports are claims; acceptance is the architect's judgment, not a DONE string.
9. **Correct efficiently** — exact mechanical fixes with an existing failing/mechanical proof may use direct `sonic`; semantic corrections should return to the existing non-isolated unit owner when available; only cold-spawn a new Terra owner when necessary. Record material corrections to locked assumptions/contracts.
10. **Record** — append decisions/results, status, verification receipts and a fresh RESUME snapshot; preserve unresolved hazards/deviations.
11. **Integrate** — sequence accepted units; external publication/merge stays user-owned (`flow-integrating`).

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
