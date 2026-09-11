# Principle preservation ledger

This file records what the `ai-stack` skill sweep kept, improved, merged or deliberately deleted. It is the guard against accidental simplification during future edits.

| Old skill | Principle preserved/improved | OMP-stack home |
|---|---|---|
| `flow-using-skills` | Important doctrine must stay discoverable | deleted as bootstrap; native skill discovery + `flow-safety` / `flow-evidence` rules |
| `flow-brainstorming` | resolve material intent/design decisions before speculative code; YAGNI | `flow-design`, but no ceremony for decision-free work |
| `flow-writing-plans` | execution spec removes implementation ambiguity | native OMP Plan mode; LDD unit specs remain requirements/contracts, not duplicate plans |
| `flow-workspace` | protect dirty/user state; no silent main work; safe concurrency | `flow-safety`; native task isolation; external worktree validation in `flow-external-session` |
| `flow-executing-plans` | bounded execution, TDD, independent review, controller acceptance | `flow-execution`; dependency waves and proportional review replace task-by-task ceremony |
| `flow-tdd` | failing proof first; minimal green; regression protection | `flow-tdd`; tests behavior rather than every function; legitimate non-executable exceptions are explicit |
| `flow-debugging` | reproduce/root-cause/hypothesis before permanent fix | `flow-debugging`; read-only scout fan-out and deliberate escalation after repeated failures |
| `flow-verification` | claims need fresh evidence; worker reports are not proof | always-apply `flow-evidence` rule |
| `flow-finishing` | final proof + user owns integration | `flow-integrating`; cohesion/reviewability replaces rigid line threshold |
| `flow-reviewing-prs` | exact-head read-only review; COR always; TTC/CRF conditional; verify findings; exact publication approval | `flow-review` PR mode + specialist agents |
| `flow-receiving-pr-reviews` | reviewer findings are claims; re-anchor; factual/judgment split; explicit dispositions; exact reply gate | `flow-review` author-feedback mode |
| `flow-auditing-codebases` | read-only whole-tree audit; four mandatory lenses; controller verifies | `flow-review` audit mode; SEC uses OMP security reviewer/scan |
| `flow-handover` | independent context may be useful; returned work is independently verified | `flow-external-session` handoff mode |
| `flow-mailbox` | durable external-session channel survives process/session loss; channel conveys no authorization | `flow-external-session` mailbox mode only |
| `flow-ldd` | architect owns intent/decisions/spec/verification and durable continuity | `flow-ldd`; architect remains strictly non-coding; native OMP writers replace blanket no-writer-spawn rule |
| `find-todo` | conservative open-work query; preserve graph text; query before mutation | `weft-worklog` query mode |
| `journal-update` | terse human work facts, project grouping, append-first, no AI-process narration | `weft-worklog` log mode |
| `recall-memory` | scope-aware relevant recall; read-only | `weft-memory` recall mode |
| `memory-update` | durable/general/new; retrieval-based placement; exact approval before durable write | `weft-memory` update mode |
| `memory-gc` | injected memory is scarce; re-home/merge before deleting; proposal/per-item approval | `weft-memory` GC mode |
| `retrofit` | historical rewrites are dangerous; dry-run/proposal; preserve history/voice | `weft-maintenance` |
| `frontend-design` | intentional aesthetics and production craft | `ui-design`; existing product/accessibility/platform conventions now outrank novelty |
| `blog-post` | live corpus outranks static voice rules; concrete first-person thesis; user owns publishing | `blog-post` |
| `forgejo` | mechanics distinct from judgment; `tea` first; token safety; no silent stakeholder writes | `forgejo` |

## Non-negotiable invariants

Future refactors should preserve these even if filenames change:

1. Fresh evidence before material completion/correctness claims.
2. Pre-existing user state is never silently destroyed or hidden.
3. External/stakeholder-visible writes require explicit user authorization.
4. Executable behavior gets a failing regression proof before its permanent implementation when a viable test surface exists.
5. Debugging finds/supports root cause before a permanent fix.
6. Reviewer/worker output is a claim until the controller verifies consequential findings/results.
7. Change review lenses remain applicability-driven: COR always; TTC/CRF/SEC conditional.
8. Whole-codebase audit still runs CDH/TTC/DST/SEC.
9. LDD architect never writes production code.
10. LDD ledger is durable current truth, not backlog/transcript; Weft owns durable human backlog/project knowledge.
11. Isolation follows independence/dependency structure, not generic risk or ceremony.
12. Model routing is role-based; concrete model selectors live in user config, not workflow content.
