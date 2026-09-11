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
config.recommended.yml      merge target; never installed automatically
mcp.example.json            optional Context7 MCP example
scripts/omp-stack           install / verify / doctor
```

## Install

The installer symlinks only repo-owned native surfaces. It refuses to replace a real file or directory and never edits `~/.omp/agent/config.yml` or `mcp.json`.

```sh
./scripts/omp-stack install
./scripts/omp-stack doctor
```

Then merge the model/task settings you want from `config.recommended.yml` into your existing OMP config. See `docs/MIGRATION.md`.

## Flow shape

The old 24-skill surface is reduced to 14 skills:

- `flow-design` — material product/architecture decisions only.
- `flow-execution` — judgment-aware routing, resumable unit ownership, dependency-aware isolation, layered verification and review waves.
- `flow-tdd` — behavior-first Red/Green/Refactor.
- `flow-debugging` — root-cause-first diagnosis.
- `flow-review` — local change, PR reviewer, PR author-feedback, and codebase-audit modes.
- `flow-integrating` — final evidence and user-owned integration decision.
- `flow-ldd` — durable architect/worker protocol for epics; architect never codes.
- `flow-external-session` — external worktrees, handoffs and filesystem mailbox only.
- `forgejo`, `ui-design`, `blog-post` — domain capabilities.
- `weft-worklog`, `weft-memory`, `weft-maintenance` — grouped Weft operations.

The old bootstrap (`flow-using-skills`), hand-written planning skill, normal workspace ceremony and standalone verification skill are gone. Native OMP discovery/Plan/isolation replace the mechanics; `flow-safety` and `flow-evidence` rules retain the invariants. Normal execution keeps semantic ownership on Terra, pushes settled mechanical leaves/corrections to Luna, preserves non-isolated unit owners when useful, and broadens evidence from leaf to final tree without ritual duplicate full-suite runs.

## Model philosophy

Skills and agents use **roles**, never concrete models. The recommended config is quota-conscious for ChatGPT Plus:

```text
Luna      discovery / mechanical / tiny background work
Terra     normal coding / implementation / auxiliary review
Sol high  planning / correctness review / hard reasoning
Sol xhigh explicit critical escalation only
```

See `docs/MODEL-ROUTING.md`. Current OMP assumptions are recorded in `docs/OMP-COMPATIBILITY.md`.

## Validation

```sh
./tests/run.sh
```

The suite validates skill/agent/rule frontmatter, role references, removed legacy assumptions, shell syntax, installer safety shape, and AI-memory slicing behavior.
