---
name: weft-worklog
description: 'Use the user''s `${WEFT_GRAPH}` human worklog: query open TODO/LATER items, log just-finished work into today''s journal, mark known completed work DONE, or pull/promote open work. Query is read-only unless the user/session explicitly owns the state change.'
---

# Weft worklog

This skill owns **human-visible work state**: open-work queries and the daily worklog.

## Graph guard

Before any operation:

```sh
[ -n "${WEFT_GRAPH:-}" ] && [ -d "${WEFT_GRAPH}" ] && echo "ok: ${WEFT_GRAPH}" || echo "MISSING"
```

Never fall back to a hardcoded path. The graph is versioned independently: never commit/sync it from this skill.

Read `references/conventions.md`; read `references/voice.md` before writing; use `references/page-archetypes.md` when creating/extending pages.

## Mode A — query open work

Search journals/pages for open `TODO` / `LATER` (surface stray `DOING` as open too), scoped to the user's explicit topic or the current session's project/context. Preserve original markdown/wiki-links/code. Group by source and sort recent-first; stale markers are triage signals, not deletion recommendations.

Default stale hints: TODO 60 days, LATER 180 days.

Query mode is read-only. Follow-on mutations happen only when the user asks — except a **known TODO this session explicitly worked from and completed**, which may be closed under the standing AGENTS doctrine.

Follow-ons:

- mark done → flip marker and add the result context appropriate to the source;
- pull into today → append a fresh TODO to today's journal, leaving historical source intact unless explicitly moving;
- promote to page-level TODO → confirm the destination page first.

## Mode B — log completed work

Pin today's date to Asia/Jakarta at write time (re-run before edit):

```sh
TZ='Asia/Jakarta' date '+%Y_%m_%d'
TZ='Asia/Jakarta' date '+%a, %d.%m.%Y'
```

Recon today's journal, a recent non-empty day and existing page names; for page authoring also sample additional relevant pages/days.

Distill human work facts, not the AI/session process: one headline accomplishment, at most three useful result/why sub-bullets, and only follow-up TODOs that actually surfaced.

Project-owned entries go under `## [[Project]]`, dropping a redundant primary project link from the bullet. Project-less one-offs stay flat above project headings. No `## Misc`.

Create/extend pages only when earned by durable substance; near-match existing page names rather than forking casing/plurals. Show touched lines/pages and ask for tweaks after writing. Never reformat unrelated history.
