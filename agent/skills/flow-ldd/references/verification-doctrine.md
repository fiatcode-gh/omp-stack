# LDD verification doctrine

The architect accepts evidence, not worker confidence.

For every returned unit:

1. Confirm the target workspace/head/patch is the intended one.
2. Inspect the actual changed files/diff.
3. Map the unit acceptance criteria to concrete evidence.
4. Run an independent instrument where practical: focused test, build, typecheck, static trace, schema validation, reproduction, or remote-state read.
5. Check cross-unit contracts and dependencies, not only the unit in isolation.
6. Record what was not verified and why.
7. If the worker disproves a spec/ledger assumption, correct the ledger as a new decision/correction before dependent work continues.

Cheap structural evidence is not automatically semantic proof: file exists ≠ feature works; command exits zero ≠ user behavior is correct; worker says tests pass ≠ architect verified the accepted target.
