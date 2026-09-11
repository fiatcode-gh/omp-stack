# LDD ledger skeleton

Default home: `.flow/ldd/<epic>/`.

At bootstrap the user chooses:

- **local** — personal architect state; normally gitignored;
- **shared** — team-visible state; tracked, with architect updates kept single-writer and small.

Do not silently change `.gitignore`; if repository state conflicts with the chosen mode, surface it as a decision.

Suggested layout:

```text
.flow/ldd/<epic>/
  LEDGER.md
  RESUME.md
  decisions/                 # shared mode or when separate records help
  units/
    <unit>.md                 # one fresh-worker-ready unit spec
  external/                  # only external-session/mailbox artifacts
```

Keep the authority small. A worker transcript belongs in OMP history; a code diff belongs in Git; backlog belongs in Weft.

## LEDGER.md

```markdown
# <Epic> — Decision Ledger

One paragraph: purpose and canonical source of inherited requirements/findings.

## Mode
- local | shared

## Current state
- merged/accepted/in-flight/blocked/next
- state which measurements are fresh vs carried forward

## Epic status
| Unit | Dependencies | State | Verification | Notes |
|---|---|---|---|---|

## Locked cross-unit contracts
- interface/data/error/compatibility decisions that workers must not re-litigate

## Environment traps
- only traps actually learned/proven during this epic

## Open questions
### User/product decisions
### External dependencies

## Decision log
Append-only. Supersede old decisions; do not rewrite history.

### <YYYY-MM-DD> — <decision>
- decided / why
- rejected / why
- consequence/locked contract

## Verification receipts
- <unit> — exact evidence/target/head and what it proves

## Corrections to inherited assumptions
- claim → corrected fact → source/evidence
```

## RESUME.md

A concise continuation entry point generated from the ledger, never higher authority than it:

```markdown
# Resume <epic>
- current accepted state
- in flight / blocked
- next decision or unit
- recent locked decisions
- traps/open questions that can burn the next session
- pointers to relevant units/evidence
```

Regenerate on meaningful wave closure, explicit handoff, and session end. Do not trigger from a guessed context threshold.
