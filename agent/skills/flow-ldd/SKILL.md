---
name: flow-ldd
description: Use for multi-story or cross-repository epics that need a durable architect-owned decision ledger across many execution waves/sessions; not for ordinary work that fits one OMP plan.
---

# Ledger-driven development (LDD)

LDD preserves a strict role split:

- **Architect/controller** owns intent, recon, decisions, specifications, unit boundaries, verification, integration sequencing and the ledger.
- **Workers** write production code.

While LDD is active, the architect **never writes production code**, including tiny corrective edits. It sends corrections back to a worker or launches a bounded worker. This keeps the long-lived context about why/what, not implementation minutiae.

The durable authority lives under `.flow/ldd/<epic>/`. Do not use `.omp/` for LDD state; `.omp/` has configuration/discovery semantics.

## Loop

1. **Re-orient** — current RESUME snapshot, epic status, decision tail, open questions, traps and in-flight unit state. Agent Hub/history is execution evidence; the ledger is current truth.
2. **Bootstrap** (new epic) — choose local vs shared ledger mode with the user and create `references/ledger-skeleton.md`.
3. **Recon** — verify inherited claims at source. Parallel read-only scouts are encouraged. Record coverage/gaps.
4. **Decide** — resolve product/architecture forks with the user. Use `flow-design` for a material decision. Lock the result in the ledger.
5. **Specify unit** — write a fresh-worker-ready unit contract: behavior, boundaries, dependencies, acceptance criteria and traps. A hard story may use native Plan mode; a well-specified ordinary story need not spend a Plan call.
6. **Dispatch** — normally OMP `flow-implementer` workers/tasks. The Terra unit owner may use nested `scout` discovery and `sonic` mechanical leaves, but retains implementation/integration responsibility. Independent top-level units may run isolated/concurrently; dependent units stay sequential. Nested leaf workers share their parent's unit workspace rather than creating isolation-inside-isolation. External top-level session/other harness → `flow-external-session`.
7. **Clarify live** — workers resolve local uncertainty themselves first. A unit owner may ask the architect/Main through `hub` when the remaining ambiguity would alter a locked behavior/scope/interface/data/architecture decision. The architect answers only inside already-authorized decisions; material clarifications/corrections are recorded in the ledger. A genuinely new decision returns through `flow-design`/user approval instead of being improvised.
8. **Verify/accept** — inspect actual patches and independently verify the unit using `references/verification-doctrine.md`. Child and unit-owner reports are claims; acceptance is the architect's judgment, not a DONE string.
9. **Record** — append decisions/results, status, verification receipts and a fresh RESUME snapshot; preserve unresolved hazards/deviations.
10. **Integrate** — sequence accepted units; external publication/merge stays user-owned (`flow-integrating`).

## Ledger boundary

The ledger is not a backlog and not a transcript. Weft remains the durable human/project backlog. The ledger holds only what a future architect needs to continue the epic correctly: current state, locked decisions/rejected alternatives, cross-unit contracts, traps, open questions, unit status, verification receipts and corrections to previous assumptions.

Worker transcripts/patches/PR discussions are evidence linked from the ledger, not copied wholesale into it.

## Coordination hierarchy

1. Same OMP session/task agents → Agent Hub/`hub`, `history://`, `agent://`.
2. Optional Vibe director mode when persistent worker conversations are specifically useful; remember it is a different session mode, not a requirement of LDD.
3. Independent top-level session/other harness → `flow-external-session` filesystem handoff/mailbox.

Never create a filesystem mailbox around ordinary OMP child agents.
