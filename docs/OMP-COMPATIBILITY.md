# OMP compatibility assumptions

This stack's v8 trial assumptions were revalidated against the public `can1357/oh-my-pi` main branch at commit `9b2a43514bfcfc0b9607ac9ac160115aec897f06` (2026-09-14). Anthropic profile selectors and adaptive-effort support were additionally re-checked against `a2501722aa05670eeab327ea1325e3fde55e51a9` / OMP 18.1.21 (2026-09-14). OMP moves quickly; re-check these assumptions when upgrading across substantial releases.

The design relies on these native behaviors:

- named profiles (`omp --profile <name>`) relocate the whole OMP-native user root to the profile-specific agent directory and do not inherit the default profile config;
- user skills are discovered from the active agent directory `skills/*/SKILL.md`;
- user task agents are discovered from `agents/*.md` and may bind arbitrary custom `modelRoles` aliases plus `autoloadSkills`; v8 uses `@execute` in addition to OMP's conventional roles;
- user rules are discovered from `rules/*.{md,mdc}`, including `alwaysApply`;
- user TypeScript/JavaScript extensions are auto-discovered from `extensions/`;
- Plan mode is read-only and owns plan approval/execution semantics;
- task batches support per-item agents and optional per-spawn isolation when `task.isolation.enabled` is on;
- task model selection comes from agent overrides/frontmatter roles rather than a per-call model field;
- headless subagents cannot prompt for approvals, so Flow constrains writer authority in the task contract and verifies results at the controller;
- child agents can coordinate with their parent/Main through `hub`; ordinary non-isolated agents are revivable after parking, while completed isolated task runs are torn down and are not revivable; unified Hub waits wake on watched job completion or peer messages, and `send` can await one peer reply; Flow deliberately prefers long bounded waits over repeated short polling or an unbounded wait;
- nested agents are depth-gated by OMP; `flow-implementer` intentionally restricts nested spawning to bundled `scout` and `sonic`;
- Agent Hub/history/agent artifacts are execution records, not replacements for LDD's durable ledger;
- bundled `reviewer` handles ordinary correctness review, while security review/scan remains OMP-native; Flow may bind its planned acceptance reviewer to `@slow`;
- ordered `bash.patterns` support explicit `prompt` rules that remain effective under yolo; those rules cover Bash only, so `tools.approval.eval: prompt` is required when eval must not bypass the normal publication-command gate; headless subagents cannot satisfy a prompt and therefore fail closed on those explicitly prompted tools;
- the first-party Anthropic provider exposes `claude-sonnet-5`, `claude-opus-5`, and `claude-fable-5-1` with adaptive effort including `high`; Haiku 4.5 is kept without an explicit effort suffix in the baseline;
- Anthropic OAuth credentials are profile-local under named profiles; the repository never stores Team credentials.

## Upgrade smoke test

After upgrading OMP:

```sh
./tests/run.sh
./scripts/omp-stack doctor
```

Then sanity-check `omp --profile openai-codex`, `omp --profile ollama-cloud`, and `omp --profile anthropic`.

Then sanity-check in OMP that `flow-planner`, `flow-plan-executor`, `flow-acceptance-reviewer`, `flow-implementer` and the Flow skills are discoverable; confirm `@execute` resolves per profile, publication Bash commands prompt, and an isolated test task exposes the `isolated` field. Do not paper over a changed OMP contract inside skills; update the native boundary deliberately.
