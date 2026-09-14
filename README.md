# omp-stack

Personal, OMP-native coding-agent stack for fiatcode.

This repository intentionally does **not** emulate the old cross-harness `ai-stack` layout. OMP owns execution mechanics — Plan mode, task agents, isolation, Agent Hub, built-in review/security — while Flow owns engineering judgment, safety, review lenses, TDD, debugging, durable epic state, and external-effect gates.

## Layout

```text
agent/
  AGENTS.md                 durable user context
  rules/                    always-apply Flow invariants
  agents/                   role-backed OMP task agents
  skills/                   optional workflow/domain capabilities
  extensions/               auto-discovered OMP extensions
  lib/                      extension support code
profiles/
  openai-codex/config.yml   first-install baseline for `omp --profile openai-codex`
  ollama-cloud/config.yml   first-install baseline for `omp --profile ollama-cloud`
  anthropic/config.yml      first-install baseline for `omp --profile anthropic`
mcp.example.json            optional Context7 MCP example
scripts/omp-stack           install / verify / doctor
```

## Install

The installer provisions three native OMP profiles: `openai-codex`, `ollama-cloud`, and `anthropic`. It symlinks the shared Flow surfaces into each profile, copies that profile's baseline `config.yml` only when one does not already exist, refuses to clobber real managed-surface files/directories, and never writes `mcp.json`.

```sh
./scripts/omp-stack install
./scripts/omp-stack doctor
```

Launch OMP directly with the native profile selector:

```sh
omp --profile openai-codex
omp --profile ollama-cloud
omp --profile anthropic
```

Existing profile configs are never overwritten; compare them with `profiles/<name>/config.yml` after stack updates. See `docs/MIGRATION.md`.

## Flow shape

The old 24-skill surface is reduced to 14 skills:

- `flow-design` — material product/architecture decisions only.
- `flow-execution` — judgment-aware routing, resumable unit ownership, dependency-aware isolation, layered verification and review waves.
- `flow-tdd` — behavior-first Red/Green/Refactor.
- `flow-debugging` — root-cause-first diagnosis.
- `flow-review` — local change, PR reviewer, PR author-feedback, and codebase-audit modes.
- `flow-integrating` — final evidence and user-owned integration decision.
- `flow-ldd` — durable architect/worker protocol for epics; architect never codes.
- `flow-external-session` — external worktrees, static planning/worker handoffs and filesystem mailbox when genuinely needed.
- `forgejo`, `ui-design`, `blog-post` — domain capabilities.
- `weft-worklog`, `weft-memory`, `weft-maintenance` — grouped Weft operations.

The old bootstrap (`flow-using-skills`), hand-written planning skill, normal workspace ceremony and standalone verification skill are gone. Native OMP discovery/Plan/isolation replace the local mechanics; validated external ChatGPT/other-harness planning handoffs can preserve already-settled design/strategy without duplicating native Plan; `flow-safety` and `flow-evidence` rules retain the invariants. Normal execution keeps semantic ownership on `@task`, pushes settled mechanical leaves/corrections to `@smol`, preserves non-isolated unit owners when useful, waits eventfully instead of polling long-running children, makes writers own safe touched-file formatting and focused proof, and broadens evidence from leaf to final tree without ritual duplicate full-suite runs. Interactive checkpoints maintain a forward pointer: what changed, what Flow will do next, and whether the user is actually needed.

## Model philosophy

Skills and agents use **roles**, never concrete models. Native OMP profiles provide provider-specific role maps while the Flow content stays shared.

The OpenAI Codex profile keeps the quota-conscious Luna → Terra → Sol ladder. The Ollama Cloud profile uses DeepSeek V4 Flash for cheap roles, GLM-5.3-Flash for routine coding/vision, DeepSeek V4 Pro for deliberate planning/review, and Kimi K3 for explicit critical escalation. The Anthropic profile uses Haiku 4.5 for cheap leaves, Sonnet 5 for semantic implementation/vision/auxiliary review, Opus 5 for Main/planning/correctness reasoning, and Fable 5.1 high for explicit critical escalation.

See `docs/MODEL-ROUTING.md`. Current OMP assumptions are recorded in `docs/OMP-COMPATIBILITY.md`.

## Validation

```sh
./tests/run.sh
```

The suite validates skill/agent/rule frontmatter, role references, removed legacy assumptions, shell syntax, installer safety shape, and AI-memory slicing behavior.
