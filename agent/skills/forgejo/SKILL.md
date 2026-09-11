---
name: forgejo
description: Use for git.fiatcode.dev / Forgejo repository, issue, pull-request, Actions or API operations where OMP's GitHub-native surfaces do not apply; prefer `tea`, protect PATs, and require user approval for stakeholder-visible writes.
---

# Forgejo

Forgejo mechanics are distinct from engineering judgment. `flow-review` decides what a review/reply should say; this skill supplies Forgejo retrieval/publication mechanics.

## Guard

Detect the remote/URL first. Use this skill only for Forgejo (`git.fiatcode.dev` or another explicitly identified Forgejo instance), not GitHub.

Never print/store a personal access token (PAT) in commands, reports, memory or logs. Prefer authenticated `tea` configuration/environment. If curl fallback is unavoidable, follow `references/curl-fallback.md` and keep credentials out of argv/history where possible.

## Daily driver

Prefer `tea` for repository/issue/PR operations and JSON output where parsing helps. `references/tea-cookbook.md` maps common GitHub-CLI habits to Forgejo.

Read operations may proceed as needed. Stakeholder-visible writes — issue/PR comments, review publication, reviewer requests, merges, releases, branch deletion on the remote — require the user's exact approval under `flow-safety`.

CI run watching is thinner than GitHub CLI; use the API fallback only when `tea` cannot answer the required question.

Migration/admin/server configuration is out of scope unless explicitly requested.
