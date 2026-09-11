#!/usr/bin/env sh
set -eu
ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT HUP INT TERM

# install + idempotence, with a user-owned config that must remain untouched
mkdir -p "$TMP/.omp/agent"
printf '%s\n' 'modelRoles:' '  default: sentinel/model' > "$TMP/.omp/agent/config.yml"
cp "$TMP/.omp/agent/config.yml" "$TMP/config.before"
HOME="$TMP" PATH="/usr/bin:/bin" "$ROOT/scripts/omp-stack" install >/dev/null
HOME="$TMP" PATH="/usr/bin:/bin" "$ROOT/scripts/omp-stack" install >/dev/null
cmp -s "$TMP/config.before" "$TMP/.omp/agent/config.yml"
for name in AGENTS.md agents rules skills extensions lib; do
  test -L "$TMP/.omp/agent/$name"
done

# Refuse to clobber a real managed-surface directory.
TMP2=$(mktemp -d)
mkdir -p "$TMP2/.omp/agent/skills"
if HOME="$TMP2" PATH="/usr/bin:/bin" "$ROOT/scripts/omp-stack" install >/dev/null 2>&1; then
  echo 'FAIL: installer overwrote/accepted real skills directory' >&2
  rm -rf "$TMP2"
  exit 1
fi
rm -rf "$TMP2"

echo 'ok: installer safety/idempotence'
