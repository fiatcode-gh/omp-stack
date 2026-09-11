# Architect handoff

Use only when moving the top-level architect responsibility to another session.

Before handoff, flush decided state into the ledger, then regenerate `RESUME.md`. The handoff message should point the new session at:

1. `.flow/ldd/<epic>/LEDGER.md` (canonical);
2. `.flow/ldd/<epic>/RESUME.md` (entry point);
3. current repository/workspace and relevant accepted heads/branches;
4. immediate task: re-orient first, do not trust the handoff summary over the ledger.

Do not duplicate the whole ledger into the handoff prompt.
