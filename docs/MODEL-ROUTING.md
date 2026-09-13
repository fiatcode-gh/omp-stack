# Model routing

The stack encodes **intent in roles**, not concrete model names. Native OMP profiles map the same role vocabulary to different providers:

```sh
omp --profile openai-codex
omp --profile ollama-cloud
```

The Flow skills/agents are symlinked into both profiles, so workflow semantics stay provider-independent while OMP keeps each profile's config, sessions, runtime database and authentication state isolated.

## Routing

| Load | Role / agent | OpenAI Codex profile | Ollama Cloud profile |
|---|---|---|---|
| tiny metadata/title/background | `@tiny` | Luna low | DeepSeek V4 Flash low |
| commit/changelog generation | `@commit` | Luna low | DeepSeek V4 Flash low |
| repo exploration | bundled `scout` / `@smol` | Luna | DeepSeek V4 Flash low |
| behavior-preserving mechanical work / diagnosed exact correction | bundled `sonic` / `@smol` | Luna | DeepSeek V4 Flash low |
| normal interactive coding | `@default` | Terra | GLM-5.3-Flash high |
| semantic delegated unit / Vibe good | `@task` | Terra | GLM-5.3-Flash high |
| TTC/CRF/audit auxiliary lenses | `@review_aux` | Terra high | DeepSeek V4 Pro high |
| deliberate native planning | `@plan` | Sol high | DeepSeek V4 Pro high |
| primary correctness review / hard reasoning | `@slow` | Sol high | DeepSeek V4 Pro high |
| vision / multimodal inspection | `@vision` | Luna | GLM-5.3-Flash high |
| exceptional security/concurrency/data-integrity escalation | `@critical` | Sol xhigh | Kimi K3 high |

`slow` intentionally stops below the most expensive explicit escalation. `critical` is the escape hatch; no automatic Flow agent binds `@critical` on purpose. Escalation should be a conscious model/session choice, not accidental fan-out.

## Provider profiles

`profiles/openai-codex/config.yml` and `profiles/ollama-cloud/config.yml` are first-install baselines, not runtime overlays. `scripts/omp-stack install` copies a baseline only when the corresponding native profile has no `config.yml`; later installs leave profile-owned config untouched.

OMP named profiles isolate the full OMP-native user root, not merely model selection. The installer therefore links the same `AGENTS.md`, agents, rules, skills, extensions and support library into both profile roots. MCP remains profile-owned and opt-in. Sessions, blobs, `agent.db` and provider authentication remain genuinely separate by design.

## Ollama Cloud selection rationale

- **DeepSeek V4 Flash** owns `smol` / `tiny` / `commit`: cheap reasoning is appropriate for discovery, mechanical leaves and background text.
- **GLM-5.3-Flash** owns `default` / `task` / `vision`: it is the routine coding lane and supplies multimodal capability. OMP currently advertises GLM 5.3 Flash reasoning at `high` / `max`, so routine work uses `high`.
- **DeepSeek V4 Pro** owns `plan` / `slow` / `review_aux`: deliberate planning and independent review get a stronger reasoning model from a different family than the routine implementer.
- **Kimi K3** owns `critical`: it is reserved for explicit frontier escalation. The profile uses `high`, matching OMP's generic Ollama Cloud effort mapping rather than inventing an unsupported `max` lane.

Keep the exact model IDs under review when OMP or Ollama Cloud changes its discovered catalog. The role topology matters more than any one model name.

## Routing principle

Use the strongest model only for **unresolved judgment**. Once behavior and the edit shape are settled, behavior-preserving propagation or an already-diagnosed exact correction can move to `sonic`. A written plan reduces rediscovery but does not automatically make semantic implementation a cheap-worker task. Direct Sonic never owns a new-behavior Red/Green decision cycle.

Main may dispatch `sonic` directly for a fully diagnosed mechanical edit; semantic unit owners may also delegate settled leaves to it. Semantic corrections should return to the existing owner when possible rather than cold-starting another reasoning session.

## Concurrency

`task.maxConcurrency: 3` allows useful fan-out without a quota-burning swarm. Flow further limits fan-out by dependency shape: only independent units/lenses run together. Unit owners normally keep no more than two useful nested cheap-model children live at once; concurrency is a ceiling, not a utilization target.

## Isolation

Enable `task.isolation.enabled: true` with `isolation.backend: auto`. This exposes per-spawn isolation as a capability; it is **not** a default for every writer.

- sole/sequential unit owner on a suitable feature checkout → normally non-isolated and resumable;
- independent concurrent writers → isolated when available;
- nested cheap-model leaves → share the unit owner's workspace, no isolation-inside-isolation;
- explicitly disposable/risky experiment → isolation when useful.

OMP resolves the actual backend with fallback. Plan mode remains read-only and does not expose task isolation.

## Effort hints

Keep `task.enableEffort: false`. Quality intent is represented by role selection. This prevents a task prompt from silently mapping a cheap worker to its model's maximum supported effort.

Do not cap `flow-implementer` below its `@task`/auto policy yet. First optimize lifecycle, verification and cheap-leaf delegation; tune model effort only after observing those changes in real sessions.

## Prewalk

Do not globally prewalk semantic implementers down to the cheap role at first write. Reasoning often continues after the first edit (test failure, redesign, integration). Instead, keep the semantic model as unit owner and explicitly delegate sufficiently mechanical leaves to bundled `sonic`; use `scout` for read-only discovery. The parent still verifies and integrates all child work.

## Review economics

Review coherent waves rather than every tiny implementation task. COR remains the strongest normal lens. TTC/CRF use `@review_aux` and run only when applicable. Security uses OMP's security specialist/scan only when the surface warrants it. Before dispatch, explicitly record run/skip dispositions for COR/TTC/CRF/SEC so conditional-lens selection is inspectable rather than implicit. After corrections, rerun affected/newly applicable lenses instead of automatically repeating the whole original set.

## Nested delegation

`flow-implementer` may spawn only `scout` and `sonic`. This uses the default shallow nested-agent budget without making implementers unrestricted orchestrators. Delegate only when a leaf has one obvious correct outcome under the approved contract and a mechanical acceptance check. Questions rise `sonic/scout → flow-implementer → Main → user/design` only as high as necessary.
