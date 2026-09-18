# LDD recon and unit specification

## Recon

Start from inherited claims, then verify them against code/docs/runtime/forge evidence. Track claim status: verified, corrected, cannot verify, or not checked.

For broad recon with separable questions, prefer bounded parallel read-only `scout` tasks for extraction/mapping (for example independent subsystems, historical source comparison, caller inventories). Do not fan out trivial recon. Scouts collect evidence; the architect synthesizes centrally and independently checks consequential facts before locking a decision.

In an indexed repository, take the structural pass from the codebase graph (`get_architecture`, `search_graph`, `trace_path`) before dispatching scouts, then let scouts verify and read the specific seams that matter. Graph rows are ranked evidence: confirm a cited path before a claim depends on it.

Recon checks what is true. It does not decide what the user wants.

Historical LDD artifacts can contain execution instructions from an older harness/version. Preserve their durable domain facts/decisions, but revalidate transport, isolation, model-routing and mailbox mechanics against the current Flow/OMP stack.

## Decide

Before specifying, resolve material intent/product/architecture forks. A ticket/audit/old plan is someone else's statement of intent, not automatic authority. Record the user's decision and rejected alternative where future re-litigation is likely.

## Unit spec

A fresh worker with no conversation should be able to execute without inventing design decisions. Include:

- goal/observable behavior;
- exact scope and explicit non-scope where useful;
- dependencies and base/accepted prerequisite units;
- locked interfaces/contracts/error semantics;
- relevant environment traps;
- behavioral acceptance criteria;
- **verification expectations**: focused proof the worker must run, whether broader/project-wide gates are safe/authorized in its workspace, and final gates reserved for Main;
- links/paths to canonical requirements/evidence.

Do not embed full implementation code merely to turn a spec into a script. Native Plan mode can produce a mechanical execution plan for unusually hard units.
