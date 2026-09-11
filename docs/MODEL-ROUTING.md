# Model routing

The stack encodes **intent in roles**, not concrete model names. `config.recommended.yml` maps those roles for the current ChatGPT Plus strategy.

## Routing

| Load | Role / agent | Intent |
|---|---|---|
| tiny metadata/title/background | `@tiny` | lowest-cost Luna |
| commit/changelog generation | `@commit` | Luna low; cheap background text generation |
| repo exploration / mechanical worker | bundled `scout` / `@smol` | Luna |
| normal interactive coding | `@default` | Terra |
| delegated implementation / Vibe good | `@task` | Terra |
| TTC/CRF/audit auxiliary lenses | `@review_aux` | Terra high |
| deliberate native planning | `@plan` | Sol high |
| primary correctness review / hard reasoning | `@slow` | Sol high |
| exceptional security/concurrency/data-integrity escalation | `@critical` | Sol xhigh, explicit only |

`slow` intentionally stops at Sol high. `critical` is the escape hatch; xhigh is not the ambient review setting. No automatic Flow agent binds `@critical` on purpose — escalation should be a conscious model/session choice, not accidental fan-out.

## Concurrency

`task.maxConcurrency: 3` allows useful fan-out without a quota-burning swarm. Flow further limits fan-out by dependency shape: only independent units/lenses run together.

## Isolation

Enable `task.isolation.enabled: true` with `isolation.backend: auto`. This only exposes per-spawn isolation; Flow still requests it only for independent concurrent writers. OMP resolves the actual backend with fallback. Plan mode remains read-only and does not expose task isolation.

## Effort hints

Keep `task.enableEffort: false`. Quality intent is already represented by role selection. This prevents a task prompt from silently mapping a cheap worker to its model's maximum supported effort.

## Prewalk

Do not globally prewalk Terra implementers down to Luna at first write. Reasoning often continues after the first edit (test failure, redesign, integration). Use Luna explicitly for known mechanical work/Vibe fast workers instead.

## Review economics

Review coherent waves rather than every tiny implementation task. COR remains the strongest normal lens. TTC/CRF use Terra high and run only when applicable. Security uses OMP's security specialist/scan only when the surface warrants it.
