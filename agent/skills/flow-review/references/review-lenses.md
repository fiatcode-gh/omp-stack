# Change review lenses

## Shared finding contract

Each specialist reviews code but never edits it. State the supplied head/scope and stop on mismatch. Existing comments are context, not truth. Report strengths and `Cannot verify` items.

Finding shape:

```text
ID: <PREFIX>-N
Severity: Critical | Important | Minor
Confidence: 0-100
Location: file:line
Title: concise defect statement
Evidence: violated requirement/contract or reproducible failure path
Impact: user/correctness/security/maintenance consequence
Remedy: specific direction, not a full patch
Verification: code traced and command run, or static evidence only
```

Critical = security compromise, data loss, outage, destructive behavior or broken primary functionality. Important = verified defect/requirement miss/regression/missing behavioral coverage/contract break/architecture violation with concrete risk. Minor = useful non-blocking cleanup/clarity.

## COR — always

Check governing requirements/rules, correctness, regressions, edge cases, compatibility, architecture, security/performance/concurrency side effects and changed failure paths. Look for swallowed errors, broad catches, unjustified fallbacks, hidden retries, misleading defaults, missing cleanup and unactionable errors. Distinguish changed defects from pre-existing code.

## TTC — conditional

Applies to executable behavior/test/validation/migration/type/schema/contract changes. Map each changed behavior to a behavioral regression test; name existing coverage when sufficient. Check boundaries, negative/error/async/integration behavior, invalid states, serialization and compatibility. Apply DDD only when repository structure/docs establish it. Never infer TDD chronology from a combined/squashed diff.

## CRF — conditional

Applies to non-trivial logic, abstractions, docs/comments, cross-module refactors, duplication/nesting or mixed responsibilities. Verify comments/docs against implementation. Check cohesion, precise names, duplication, needless abstraction, deep nesting and separable concerns. No rigid line-count threshold. Polish is normally Minor unless concrete maintenance/correctness risk raises it.

## SEC — conditional

Applies when a meaningful security boundary changed. Prefer OMP's security specialist/native security scan rather than reimplementing a security checklist here. Validate important security findings against the exact target snapshot before synthesis.
