#!/usr/bin/env sh
set -eu
ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT HUP INT TERM

# Keep the default profile untouched and preseed one named profile config. The
# installer must preserve existing profile config while bootstrapping the other.
mkdir -p "$TMP/.omp/agent" "$TMP/.omp/profiles/openai-codex/agent"
printf '%s\n' 'default sentinel' > "$TMP/.omp/agent/AGENTS.md"
printf '%s\n' 'modelRoles:' '  default: sentinel/model' > "$TMP/.omp/profiles/openai-codex/agent/config.yml"
cp "$TMP/.omp/profiles/openai-codex/agent/config.yml" "$TMP/openai.before"

HOME="$TMP" PATH="/usr/bin:/bin" "$ROOT/scripts/omp-stack" install >/dev/null
HOME="$TMP" PATH="/usr/bin:/bin" "$ROOT/scripts/omp-stack" install >/dev/null

cmp -s "$TMP/openai.before" "$TMP/.omp/profiles/openai-codex/agent/config.yml"
cmp -s "$ROOT/profiles/ollama-cloud/config.yml" "$TMP/.omp/profiles/ollama-cloud/agent/config.yml"
cmp -s "$ROOT/profiles/anthropic/config.yml" "$TMP/.omp/profiles/anthropic/agent/config.yml"
grep -q 'default sentinel' "$TMP/.omp/agent/AGENTS.md"

for profile in openai-codex ollama-cloud anthropic; do
  for name in AGENTS.md agents rules skills extensions lib; do
    test -L "$TMP/.omp/profiles/$profile/agent/$name"
  done
done

HOME="$TMP" PATH="/usr/bin:/bin" "$ROOT/scripts/omp-stack" verify >/dev/null

# Respect PI_CONFIG_DIR in fallback mode; named profiles intentionally do not use
# PI_CODING_AGENT_DIR.
TMP_CFG=$(mktemp -d)
HOME="$TMP_CFG" PI_CONFIG_DIR=.custom PI_CODING_AGENT_DIR="$TMP_CFG/ignored" PATH="/usr/bin:/bin" "$ROOT/scripts/omp-stack" install >/dev/null
test -L "$TMP_CFG/.custom/profiles/openai-codex/agent/skills"
test -L "$TMP_CFG/.custom/profiles/anthropic/agent/skills"
test ! -e "$TMP_CFG/ignored/skills"
rm -rf "$TMP_CFG"

# When OMP is available, resolve profile roots through native `omp --profile ... config path`.
TMP_NATIVE=$(mktemp -d)
mkdir -p "$TMP_NATIVE/bin"
cat > "$TMP_NATIVE/bin/omp" <<'SH'
#!/usr/bin/env sh
set -eu
[ "$1" = "--profile" ]
profile=$2
[ "$3" = "config" ]
[ "$4" = "path" ]
printf '%s/native/%s/agent\n' "$HOME" "$profile"
SH
chmod +x "$TMP_NATIVE/bin/omp"
HOME="$TMP_NATIVE" PATH="$TMP_NATIVE/bin:/usr/bin:/bin" "$ROOT/scripts/omp-stack" install >/dev/null
test -L "$TMP_NATIVE/native/openai-codex/agent/skills"
test -L "$TMP_NATIVE/native/ollama-cloud/agent/skills"
test -L "$TMP_NATIVE/native/anthropic/agent/skills"
rm -rf "$TMP_NATIVE"

# Refuse to clobber a real managed-surface directory inside a managed profile.
TMP2=$(mktemp -d)
mkdir -p "$TMP2/.omp/profiles/ollama-cloud/agent/skills"
if HOME="$TMP2" PATH="/usr/bin:/bin" "$ROOT/scripts/omp-stack" install >/dev/null 2>&1; then
  echo 'FAIL: installer overwrote/accepted real profile skills directory' >&2
  rm -rf "$TMP2"
  exit 1
fi
rm -rf "$TMP2"

echo 'ok: profile installer safety/idempotence'
