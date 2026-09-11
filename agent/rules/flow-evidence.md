---
name: flow-evidence
description: Always-on evidence discipline for completion, worker results and destructive decisions.
alwaysApply: true
---

# Flow evidence

No material completion/correctness claim without fresh evidence appropriate to that claim.

- Run the proving command now when a command is the proof; read its whole relevant output and exit status.
- `tests pass` requires the appropriate complete test command with zero relevant failures. `build works` requires a successful build. `bug fixed` requires the original symptom/reproduction to be gone.
- Agent/subagent reports are claims, not proof. Inspect the actual patch/files and independently verify consequential claims before accepting them. Delegation never transfers verification responsibility: each parent owns acceptance of its children's work, and Main still owns acceptance of the resulting unit.
- Old output is historical evidence, not fresh evidence for the current tree/head.
- A successful edit/tool call proves only that the tool reported success, not that behavior is correct.
- If full proof is unavailable, state exactly what was verified, what was not, and why. Never upgrade partial evidence into a stronger claim.
- Before a destructive or irreversible action based on a registry/version/API/remote-state claim, re-check the literal current source yourself.
