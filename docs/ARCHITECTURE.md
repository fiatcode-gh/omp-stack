# Architecture

## Boundary

`omp-stack` is OMP-native. It may borrow content principles from the old multi-harness `ai-stack`, but OMP runtime must not depend on an `ai-stack` checkout.

Native surfaces:

- `agent/AGENTS.md` → broad durable user context;
- `agent/rules/*.md` → always-visible hard invariants;
- `agent/agents/*.md` → specialist execution identities + role routing;
- `agent/skills/*/SKILL.md` → optional workflows/domain knowledge;
- `agent/extensions/*.ts` → OMP runtime extensions.

## Old → new skill map

| Old | New |
|---|---|
| flow-using-skills | delete; native discovery + rules |
| flow-brainstorming | flow-design |
| flow-writing-plans | flow-planning doctrine + native OMP `@plan` routing |
| flow-workspace | flow-safety rule + flow-external-session when external |
| flow-executing-plans | flow-execution |
| flow-verification | flow-evidence rule |
| flow-finishing | flow-integrating |
| flow-reviewing-prs | flow-review PR mode |
| flow-receiving-pr-reviews | flow-review author-feedback mode |
| flow-auditing-codebases | flow-review audit mode |
| flow-handover + flow-mailbox | flow-external-session |
| flow-ldd | flow-ldd, OMP-native worker transport |
| flow-tdd | flow-tdd (behavior-oriented) |
| flow-debugging | flow-debugging |
| find-todo + journal-update | weft-worklog |
| recall-memory + memory-update + memory-gc | weft-memory |
| retrofit | weft-maintenance |
| frontend-design | ui-design |
| blog-post | blog-post |
| forgejo | forgejo |

## Execution hierarchy

The normal Flow execution model is shared by ordinary work, approved Plans and LDD units. Route by remaining judgment rather than by file count alone:

```text
Main/controller (@default)
├── flow-planner (@plan) — judgment-heavy execution plan author, no production code
├── scout (@smol) — bounded read-only recon
├── sonic (@smol) — direct behavior-preserving mechanical edit / diagnosed exact correction
├── flow-plan-executor (@execute) — constrained owner for execution-grade plan work
└── flow-implementer (@task) — semantic/debugging/broken-plan fallback
    ├── scout (@smol) — bounded local discovery
    └── sonic (@smol) — settled mechanical leaf edits

planned coherent result → flow-acceptance-reviewer (@slow)
```

The planning stage locks consequential interfaces/tests/ownership/error semantics and explicit executor discretion. A plan executor may implement new behavior because that judgment was paid upstream, but it cannot redesign; contradictions rise to Main/planning. The semantic `@task` owner remains available when judgment genuinely cannot be removed from execution.

A sole/sequential owner on a suitable feature checkout is normally non-isolated so it can be messaged/revived. One plan executor may continue across adjacent sequential plan tasks to reduce cold starts. Isolation remains primarily for independent concurrent writers or explicitly disposable experiments. Long waits remain event-driven.

## Evidence hierarchy

Evidence broadens with ownership rather than repeating the same full gate everywhere:

```text
leaf proof → unit proof → integration/review proof → final-tree gate
```

Writers must verify their own changes, including canonical formatting of touched files when the formatter can be safely scoped. Writer dispatch has a verification-capable preflight: focused proof, touched-file formatting, focused static/build checks and Main-owned broader gates are stated explicitly before spawn. A blanket "do not verify because Main will" brief is invalid; the implementer also detects that contradiction so one controller mistake cannot silently recreate a blind worker. Parent/controller verification remains independent for consequential claims, but independence does not require ritual duplicate whole-repository runs when a targeted different proof better covers the boundary. Evidence may be reused only while its exact tree/head/environment remains unchanged. Temporary probes against pre-existing dirty files restore against a captured pre-edit snapshot, never against `HEAD`.

Interactive Flow also keeps a **forward pointer**: at meaningful user-facing checkpoints Main states the outcome, the next workflow action, and whether user input is required. Internal authorized next actions continue automatically; concrete questions are reserved for real design/approval/integration gates.

## Planning and review

Execution-grade planned work applies COR/TTC/CRF/SEC as one integrated **plan quality gate** before coding, then uses `flow-acceptance-reviewer` for one strong final independent acceptance pass. That reviewer checks both plan conformance and correctness so plan defects are still findings. Verified material findings are batched into one correction wave; one scoped closure review is the default ceiling.

Standalone/unplanned changes, PR review and audits still use the existing specialist doctrine: bundled COR/security plus Flow TTC/Craft/audit lenses as applicable. The lenses remain principles of record; v8 changes when they are paid for, not what they mean.

## LDD

LDD state lives under `.flow/ldd`, never `.omp`, because `.omp` affects OMP discovery/config semantics. Agent Hub/transcripts capture execution history; the ledger captures durable project decisions/state and outranks conversation summaries after compaction/resume.

The ledger does **not** permanently own harness mechanics. Historical mailbox/isolation/model-routing instructions are version-sensitive and must be revalidated against the current Flow/OMP stack on resume.
