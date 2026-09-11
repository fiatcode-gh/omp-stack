#!/usr/bin/env sh
set -eu
ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
cd "$ROOT"

uv run --with pyyaml python tests/validate.py
node --no-warnings --experimental-strip-types tests/ai-memory.test.mjs
sh -n scripts/omp-stack
./tests/install.test.sh
sh -n agent/skills/flow-external-session/scripts/mailbox
bash -n agent/skills/flow-review/scripts/collect-forgejo-context.sh
printf '%s\n' 'ok: shell syntax'
