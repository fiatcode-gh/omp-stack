# Curl fallback — API-only ops `tea` doesn't expose

Use only when `tea` has no command for what you need. Prefer the repository's
configured Forgejo host rather than hardcoding a second credential source.

If the repository push credential has the required API scope, obtain it through
`git credential fill`. Keep the value out of command arguments, shell history,
logs, reports and memory. Do not enable shell xtrace while a credential is in a
shell variable.

```bash
FORGEJO_HOST=git.fiatcode.dev
API="https://$FORGEJO_HOST/api/v1"
PAT=$(printf 'protocol=https\nhost=%s\n\n' "$FORGEJO_HOST" \
  | git credential fill | sed -n 's/^password=//p')

# Feed the Authorization header to curl over stdin so the token is not placed
# in curl's argv. Extra curl arguments follow the URL.
forgejo_curl() {
  url=$1
  shift
  printf 'header = "Authorization: token %s"\n' "$PAT" \
    | curl -fsS --config - "$@" "$url"
}
```

If this credential is rejected for scope, use the credential already managed by
`tea`; do not print/copy a token into a command line just to make the fallback
work.

## Toggle the Actions unit (migration one-off)

Migrated repos may have Actions disabled. Enable it only when the user intends
that repository to run Actions:

```bash
forgejo_curl "$API/repos/<owner>/<repo>" \
  -X PATCH \
  -H 'Content-Type: application/json' \
  -d '{"has_actions": true}'
```

## Watch a run to completion (`gh run watch` equivalent)

When `tea` has no live run-watch, poll the tasks endpoint until terminal:

```bash
forgejo_curl "$API/repos/<owner>/<repo>/actions/tasks" \
  | jq '.workflow_runs[0] // .tasks[0]'
```

Re-poll at a reasonable interval until status is no longer running/waiting, then
report success/failure. On failure, follow the run URL from the task payload or
confirm the current Forgejo API before scripting a version-specific log endpoint.

## Secrets (names are readable; values are write-only)

```bash
forgejo_curl "$API/repos/<owner>/<repo>/actions/secrets" | jq '.[].name'
```
