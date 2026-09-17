# LDD verification doctrine

The architect accepts evidence, not worker confidence. Worker self-verification and architect acceptance are complementary.

For every returned unit:

1. Confirm the target workspace/head/patch is the intended one.
2. Inspect the actual changed files/diff.
3. Confirm the worker produced focused repository-native proof for its changed surface; if it could have proved a basic compile/type/format/test claim but did not, send it back rather than making blind work normal.
4. Map the unit acceptance criteria to concrete evidence.
5. Run an independent instrument for the consequential claim/integration boundary where practical: focused test, build, typecheck, static trace, schema validation, reproduction, or remote-state read. Independence does not require rerunning the exact same whole-repository suite when a narrower/different proof tests the acceptance boundary better.
6. Check cross-unit contracts and dependencies, not only the unit in isolation.
7. Reuse recent proof by claim dependency rather than ritual tree/head identity: a later change stales only proof whose dependency surface it can affect. When carrying proof across a changed tree/head, state why the intervening diff cannot affect the reused claim and rerun proof whose dependency surface is uncertain.
8. Record what was not verified and why.
9. If the worker disproves a spec/ledger assumption, correct the ledger as a new decision/correction before dependent work continues.

Evidence should become broader as ownership rises: leaf → unit → integration → final tree. Cheap structural evidence is not automatically semantic proof: file exists ≠ feature works; command exits zero ≠ user behavior is correct; worker says tests pass ≠ architect verified the accepted target.
