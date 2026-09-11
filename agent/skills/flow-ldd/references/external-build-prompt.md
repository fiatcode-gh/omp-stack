# External LDD worker prompt

Only for an independently launched top-level session/other harness.

The prompt must identify:

- repository + user-provided/validated worktree path;
- branch/base/current head;
- one unit specification path;
- locked contracts/traps relevant to the unit;
- required workflow (`flow-tdd` / root-cause discipline as applicable);
- exact acceptance/verification expectations;
- report path/mailbox if asynchronous communication is needed;
- forbidden external writes (push/PR/review/merge/release) unless separately approved.

The external worker does not edit the architect ledger directly unless the shared-mode protocol explicitly assigns it a single-writer artifact. It reports evidence/corrections back to the architect.
