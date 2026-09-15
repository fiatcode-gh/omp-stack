// Behavioral tests for the narrow Flow runtime orchestration guard.
// Dependency-free: Node native TypeScript stripping loads the extension directly.
import assert from "node:assert/strict";
import guardExtension from "../agent/extensions/flow-orchestration-guard.ts";

let toolCall;
guardExtension({
	on(event, handler) {
		if (event === "tool_call") toolCall = handler;
	},
});

assert.equal(typeof toolCall, "function", "guard must register a tool_call handler");

const call = (toolName, input, hasUI = true) =>
	toolCall({ toolName, input }, { hasUI });

let result = await call("hub", { op: "wait" });
assert.equal(result?.block, true, "interactive bare hub wait must be blocked");

result = await call("hub", { op: "wait", ids: ["job-1"] });
assert.equal(result?.block, true, "interactive job wait must be blocked");

result = await call("hub", { op: "wait", name: "server" });
assert.equal(result, undefined, "named process wait must remain allowed");

result = await call("hub", { op: "wait", from: "worker-a" });
assert.equal(result, undefined, "targeted peer wait must remain allowed");

result = await call("hub", { op: "wait", from: "worker-a", ids: ["job-1"] });
assert.equal(result?.block, true, "peer wait carrying job ids must be blocked");

result = await call("hub", { op: "wait", ids: ["job-1"] }, false);
assert.equal(result, undefined, "headless/non-interactive wait is outside Main guard scope");

const capsuleWithoutId = `Evidence capsule:
- Owns: one coherent scene
- Independent split check: none
- Excludes: other scenes
- Restore obligation: NONE`;
result = await call("task", {
	agent: "flow-evidence-verifier",
	task: capsuleWithoutId,
});
assert.equal(result?.block, true, "verifier capsule without ID must be blocked");
assert.match(result.reason, /id:/i, "missing-ID rejection must name the marker");

const completeCapsule = `Evidence capsule:
- ID: scene-a
- Owns: one coherent scene
- Independent split check: none
- Excludes: other scenes
- Restore obligation: NONE`;
result = await call("task", {
	agent: "flow-evidence-verifier",
	task: completeCapsule,
});
assert.equal(result, undefined, "complete verifier capsule must be allowed");

result = await call("task", {
	tasks: [
		{ agent: "scout", task: "read only" },
		{ agent: "flow-evidence-verifier", task: capsuleWithoutId },
	],
});
assert.equal(result?.block, true, "batch verifier capsule without ID must be blocked");
assert.match(result.reason, /tasks\[1\].*id:/i, "batch rejection must identify the bad task");

console.log("ok: flow orchestration guard");
