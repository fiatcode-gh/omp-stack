# Migration from ai-stack OMP tenant

Your previous default OMP config registered:

```yaml
extensions:
  - .../ai-stack/omp/extensions/flow-skills.ts
  - .../ai-stack/omp/extensions/ai-memory.ts
skills:
  customDirectories:
    - .../ai-stack/shared/skills
```

The profiled stack should not carry those entries forward.

Why:

- `flow-skills.ts` injected the old bootstrap; OMP now discovers the redesigned skills/rules natively.
- the old `customDirectories` points at obsolete same-named Flow skills and can shadow/collide with the OMP-native set.
- `ai-memory.ts` is auto-discovered from each active profile's `extensions/` symlink after install, so an explicit path is unnecessary.

## Recommended sequence

1. Extract/clone `omp-stack` somewhere stable.
2. Run `./scripts/omp-stack install`. This provisions `openai-codex` and `ollama-cloud` under OMP's native profile roots.
3. If a profile already had `config.yml`, compare/merge it with `profiles/<name>/config.yml`; the installer never overwrites an existing profile config.
4. Remove any old `ai-stack` `extensions:` registrations and `skills.customDirectories` entries from the profile configs.
5. Authenticate each profile/provider as needed. Named OMP profiles do not inherit runtime/auth state from the default profile or from each other. `OLLAMA_CLOUD_API_KEY` may instead be supplied through the environment.
6. Optionally copy `mcp.example.json` to a profile's `mcp.json` if you use Context7. MCP is intentionally profile-owned and the installer never writes credentials.
7. Run `./scripts/omp-stack verify` and `./scripts/omp-stack doctor`.
8. Launch with native OMP profile selection:

   ```sh
   omp --profile openai-codex
   omp --profile ollama-cloud
   ```

The old default `~/.omp/agent` tree is left untouched. Delete or retire it only after both named profiles behave as expected.

## Routing changes

The OpenAI Codex profile preserves the current quota-conscious routing:

- `task`: Terra;
- `plan` / `slow`: Sol high;
- `review_aux`: Terra high;
- `critical`: Sol xhigh;
- `commit`: Luna low;
- `task.enableEffort: false`, `maxConcurrency: 3`, per-spawn isolation enabled with backend `auto`.

The Ollama Cloud profile maps the same roles to:

- `smol` / `tiny` / `commit`: DeepSeek V4 Flash low;
- `default` / `task` / `vision`: GLM-5.3-Flash high;
- `plan` / `slow` / `review_aux`: DeepSeek V4 Pro high;
- `critical`: Kimi K3 high.

See `docs/MODEL-ROUTING.md` for the reasoning.
