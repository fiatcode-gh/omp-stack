# Migration from ai-stack OMP tenant

Your previous OMP config registered:

```yaml
extensions:
  - .../ai-stack/omp/extensions/flow-skills.ts
  - .../ai-stack/omp/extensions/ai-memory.ts
skills:
  customDirectories:
    - .../ai-stack/shared/skills
```

The new stack should remove those entries after installation.

Why:

- `flow-skills.ts` injected the old bootstrap; OMP now discovers the redesigned skills/rules natively.
- the old `customDirectories` points at obsolete same-named Flow skills and can shadow/collide with the OMP-native set.
- `ai-memory.ts` is auto-discovered from `~/.omp/agent/extensions` after install, so an explicit path is unnecessary.

## Recommended sequence

1. Extract/clone `omp-stack` somewhere stable.
2. Run `./scripts/omp-stack install`.
3. Merge `config.recommended.yml` into your existing `~/.omp/agent/config.yml` rather than replacing it.
4. Remove the old `ai-stack` `extensions:` registrations and `skills.customDirectories` entry shown above.
5. Keep your personal theme/statusline/provider keys; the recommended file already mirrors the attached config as a starting point.
6. Optionally copy `mcp.example.json` to `~/.omp/agent/mcp.json` and insert your Context7 key if you use it. The installer never writes credentials.
7. Run `./scripts/omp-stack verify` and `./scripts/omp-stack doctor`.

## Important routing change

Compared with the attached config:

- `slow`: Sol xhigh → **Sol high**;
- add `review_aux`: Terra high;
- add `critical`: Sol xhigh;
- add `commit`: Luna low;
- keep `task`: Terra and `plan`: Sol high;
- enable per-spawn task isolation with backend `auto`;
- keep `task.enableEffort: false`, `maxConcurrency: 3`.
