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

The old 24-skill surface is reduced to 15 skills in the v8 trial:

* `flow-design` — material product/architecture decisions only.
* `flow-planning` — execution-grade HOW planning; front-loads interfaces/tests/ownership and lens concerns so implementation can be constrained.
* `flow-execution` — routes execution-grade work to cheap constrained executors, preserves semantic fallback, layered verification and bounded acceptance review.
* `flow-tdd` — behavior-first Red/Green/Refactor.
* `flow-debugging` — root-cause-first diagnosis.
* `flow-review` — local change, PR reviewer, PR author-feedback, and codebase-audit modes.
* `flow-integrating` — final evidence and user-owned integration decision.
* `flow-ldd` — durable architect/worker protocol for epics; architect never codes.
* `flow-external-session` — external worktrees, static planning/worker handoffs and filesystem mailbox when genuinely needed.
* `forgejo`, `ui-design`, `blog-post` — domain capabilities.
* `weft-worklog`, `weft-memory`, `weft-maintenance` — grouped Weft operations.

The old bootstrap (`flow-using-skills`), normal workspace ceremony and standalone verification skill remain gone. v8 deliberately restores **Flow planning doctrine** on top of native OMP Plan/model mechanics: substantial work becomes contract → execution-grade plan → constrained `@execute` implementation → one strong `@slow` acceptance review. `@task` remains the semantic/debugging fallback and `@smol` the mechanical lane. Review lenses are not deleted: they move left into the plan quality gate for planned work and remain specialist reviewers for unplanned/PR/audit paths. Writers still own focused proof, Main owns integration/final evidence, and LDD resumes from small durable pointers instead of replaying the whole epic.

## Model philosophy

Skills and agents use **roles**, never concrete models. Native OMP profiles provide provider-specific role maps while the Flow content stays shared.

The OpenAI Codex v8 trial keeps Terra as Main, uses Sol for planning/final acceptance, and adds Luna as `@execute` for decision-complete plan work. The Ollama Cloud trial keeps DeepSeek V4 Pro as Main/planning/final acceptance, uses DeepSeek V4.1 Flash for cheap mechanical roles, GLM-5.3-Flash for constrained execution/semantic coding/vision and auxiliary review, and Kimi K3 for explicit critical escalation. The Anthropic v8 profile uses Haiku 4.5 for cheap leaves, Sonnet 5 for constrained execution/semantic implementation/vision/auxiliary review, Opus 5 for Main/planning/correctness reasoning, and Fable 5.1 high for explicit critical escalation.

See `docs/MODEL-ROUTING.md`. Current OMP assumptions are recorded in `docs/OMP-COMPATIBILITY.md`.

## Validation

```sh
./tests/run.sh
```

The suite validates skill/agent/rule frontmatter, role references, removed legacy assumptions, shell syntax, installer safety shape, and AI-memory slicing behavior.
