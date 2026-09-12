# Model routing

The stack encodes **intent in roles**, not concrete model names. `config.recommended.yml` maps those roles for the current ChatGPT Plus strategy.

## Routing

| Load | Role / agent | Intent |
|---|---|---|
| tiny metadata/title/background | `@tiny` | lowest-cost Luna |
| commit/changelog generation | `@commit` | Luna low; cheap background text generation |
| repo exploration | bundled `scout` / `@smol` | Luna |
| behavior-preserving mechanical work / diagnosed exact correction | bundled `sonic` / `@smol` | Luna medium |
| normal interactive coding | `@default` | Terra |
| semantic delegated unit / Vibe good | `@task` | Terra |
| TTC/CRF/audit auxiliary lenses | `@review_aux` | Terra high |
| deliberate native planning | `@plan` | Sol high |
| primary correctness review / hard reasoning | `@slow` | Sol high |
| exceptional security/concurrency/data-integrity escalation | `@critical` | Sol xhigh, explicit only |

`slow` intentionally stops at Sol high. `critical` is the escape hatch; xhigh is not the ambient review setting. No automatic Flow agent binds `@critical` on purpose — escalation should be a conscious model/session choice, not accidental fan-out.

## Routing principle

Use the strongest model only for **unresolved judgment**. Once behavior and the edit shape are settled, behavior-preserving propagation or an already-diagnosed exact correction can move to `sonic`. A written plan reduces rediscovery but does not automatically make semantic implementation a Luna task. Direct Sonic never owns a new-behavior Red/Green decision cycle.

Main may dispatch `sonic` directly for a fully diagnosed mechanical edit; Terra unit owners may also delegate settled leaves to it. Semantic corrections should return to the existing Terra owner when possible rather than cold-starting another Terra session.

## Concurrency

`task.maxConcurrency: 3` allows useful fan-out without a quota-burning swarm. Flow further limits fan-out by dependency shape: only independent units/lenses run together. Terra owners normally keep no more than two useful nested Luna children live at once; concurrency is a ceiling, not a utilization target.

## Isolation

Enable `task.isolation.enabled: true` with `isolation.backend: auto`. This exposes per-spawn isolation as a capability; it is **not** a default for every writer.

- sole/sequential unit owner on a suitable feature checkout → normally non-isolated and resumable;
- independent concurrent writers → isolated when available;
- nested Luna leaves → share the Terra owner's workspace, no isolation-inside-isolation;
- explicitly disposable/risky experiment → isolation when useful.

OMP resolves the actual backend with fallback. Plan mode remains read-only and does not expose task isolation.

## Effort hints

Keep `task.enableEffort: false`. Quality intent is already represented by role selection. This prevents a task prompt from silently mapping a cheap worker to its model's maximum supported effort.

Do not cap `flow-implementer` below its `@task`/auto policy yet. First optimize lifecycle, verification and Luna delegation; only tune Terra effort after observing those changes in real sessions.

## Prewalk

Do not globally prewalk Terra implementers down to Luna at first write. Reasoning often continues after the first edit (test failure, redesign, integration). Instead, keep Terra as the unit owner and explicitly delegate sufficiently mechanical leaves to bundled `sonic`; use `scout` for read-only discovery. The parent still verifies and integrates all child work.

## Review economics

Review coherent waves rather than every tiny implementation task. COR remains the strongest normal lens. TTC/CRF use Terra high and run only when applicable. Security uses OMP's security specialist/scan only when the surface warrants it. Before dispatch, explicitly record run/skip dispositions for COR/TTC/CRF/SEC so conditional-lens selection is inspectable rather than implicit. After corrections, rerun affected/newly applicable lenses instead of automatically repeating the whole original set.

## Nested delegation

`flow-implementer` may spawn only `scout` and `sonic`. This uses the default shallow nested-agent budget without making implementers unrestricted orchestrators. Delegate only when a leaf has one obvious correct outcome under the approved contract and a mechanical acceptance check. Questions rise `sonic/scout → flow-implementer → Main → user/design` only as high as necessary.
