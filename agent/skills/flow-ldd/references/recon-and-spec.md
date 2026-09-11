# LDD recon and unit specification

## Recon

Start from inherited claims, then verify them against code/docs/runtime/forge evidence. Track claim status: verified, corrected, cannot verify, or not checked. Prefer multiple read-only scouts for independent subsystems, but synthesize centrally.

Recon checks what is true. It does not decide what the user wants.

## Decide

Before specifying, resolve material intent/product/architecture forks. A ticket/audit/old plan is someone else's statement of intent, not automatic authority. Record the user's decision and rejected alternative where future re-litigation is likely.

## Unit spec

A fresh worker with no conversation should be able to execute without inventing design decisions. Include:

- goal/observable behavior;
- exact scope and explicit non-scope where useful;
- dependencies and base/accepted prerequisite units;
- locked interfaces/contracts/error semantics;
- relevant environment traps;
- behavioral acceptance criteria and verification expectations;
- links/paths to canonical requirements/evidence.

Do not embed full implementation code merely to turn a spec into a script. Native Plan mode can produce a mechanical execution plan for unusually hard units.
