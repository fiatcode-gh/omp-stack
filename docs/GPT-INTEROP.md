# ChatGPT ↔ OMP Flow interoperability

The ChatGPT Flow port and this OMP stack share **doctrine**, not identical mechanics.

## Shared surface

- `flow-design` — material WHAT/WHY decisions.
- `flow-review` — evidence-backed PR/change/audit review doctrine.
- `flow-ldd` — durable architect/ledger semantics.
- `flow-planning` — shared execution-grade planning doctrine; ChatGPT and OMP use different mechanics but the same plan contract/lens quality gate.

OMP additionally owns local execution/TDD/debugging/integration, task agents, Hub/isolation and formatter/test ownership. Do not copy those mechanics into the ChatGPT planning skills.

## Handoff rule

ChatGPT emits a versioned static `FLOW-HANDOFF.json` + `HANDOFF.md` bundle using the schema in `agent/skills/flow-external-session/references/planning-handoff.md`. When the user explicitly intends to continue in local OMP, that machine-readable bundle is mandatory; a standalone Markdown plan/design is only legacy evidence, not a complete protocol handoff. OMP validates and reconciles the bundle before use. The bundle may carry decisions and implementation strategy, but **never authorization**. Do not use embedded copy/paste kickoff prompts as a second orchestration protocol; the receiving OMP stack owns current mechanics.

For LDD, an existing local `LEDGER.md` remains canonical. ChatGPT may propose ledger/unit changes; the local architect accepts/rejects and records them. For a new epic, local OMP still establishes local/shared ledger mode before the proposal becomes canonical.

## Avoid duplicate reasoning

After validation:

- unresolved WHAT/WHY → `flow-design`;
- settled design + execution-grade current plan → request/confirm local execution approval, then constrained `flow-execution`;
- settled strategy but executor would still make consequential HOW/test/interface decisions → preserve the strategy and use `flow-planning` only to make those missing decisions execution-grade;
- tiny obvious implementation with no meaningful planning judgment → authorized semantic/direct execution without plan ceremony.

ChatGPT handoffs should evolve toward the same execution-grade plan shape (locked decisions, task briefs, proof, discretion/escalation and plan quality-gate receipt). Until the GPT port is updated, an `IMPLEMENTATION-PLAN.md` may be strategy-quality and must be graded rather than blindly treated as cheap-executor-ready.

A changed commit SHA triggers targeted revalidation, not automatic rejection or a full restart. A matching SHA does not erase local dirty-tree or ledger differences.

## Synchronization discipline

When shared doctrine changes in OMP (`flow-design`, review lens semantics, LDD authority/continuity, handoff schema), update the ChatGPT skill port in the same change cycle. OMP-only execution mechanics do not require a ChatGPT mirror.
