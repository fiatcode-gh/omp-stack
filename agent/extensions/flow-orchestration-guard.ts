import type { ExtensionAPI } from "@oh-my-pi/pi-coding-agent";

type ToolInput = Record<string, unknown>;

const VERIFIER = "flow-evidence-verifier";
const CAPSULE_MARKERS = [
	"evidence capsule:",
	"id:",
	"owns:",
	"independent split check:",
	"excludes:",
	"restore obligation:",
] as const;

function nonEmptyString(value: unknown): boolean {
	return typeof value === "string" && value.trim().length > 0;
}

function missingCapsuleMarkers(task: unknown): string[] {
	if (typeof task !== "string") return [...CAPSULE_MARKERS];
	const lower = task.toLowerCase();
	return CAPSULE_MARKERS.filter((marker) => !lower.includes(marker));
}

function verifierBriefErrors(input: ToolInput): string[] {
	const errors: string[] = [];
	const check = (agent: unknown, task: unknown, label: string) => {
		if (agent !== VERIFIER) return;
		const missing = missingCapsuleMarkers(task);
		if (missing.length > 0) errors.push(`${label}: missing ${missing.join(", ")}`);
	};

	check(input.agent, input.task, "task");
	if (Array.isArray(input.tasks)) {
		input.tasks.forEach((item, index) => {
			if (!item || typeof item !== "object") return;
			const record = item as ToolInput;
			check(record.agent, record.task, `tasks[${index}]`);
		});
	}
	return errors;
}

export default function (pi: ExtensionAPI) {
	pi.on("tool_call", async (event, ctx) => {
		const input = event.input as ToolInput;

		if (event.toolName === "hub" && ctx.hasUI && input.op === "wait") {
			const processWait = nonEmptyString(input.name);
			const peerWait = nonEmptyString(input.from);
			const jobIds = Array.isArray(input.ids) && input.ids.length > 0;

			if (!processWait && !(peerWait && !jobIds)) {
				return {
					block: true,
					reason:
						"Flow orchestration guard: interactive Main cannot block on hub wait for child/job completion. Child results self-deliver; return foreground control. Use hub wait with name for a supervised process, or from without ids for a targeted peer reply.",
				};
			}
		}

		if (event.toolName === "task") {
			const errors = verifierBriefErrors(input);
			if (errors.length > 0) {
				return {
					block: true,
					reason:
						`Flow evidence-capsule preflight failed: ${errors.join("; ")}. ` +
						"Each flow-evidence-verifier task must declare one bounded capsule before dispatch.",
				};
			}
		}
	});
}
