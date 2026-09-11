#!/usr/bin/env bash
set -euo pipefail

readonly REQUEST_TIMEOUT=30s
readonly MAX_PAGES=100

fail() {
  printf 'collect-forgejo-context: %s\n' "$*" >&2
  exit 1
}

if [[ $# -ne 2 ]]; then
  fail "usage: $0 PR_NUMBER PACKET_DIRECTORY"
fi

number=$1
packet_dir=$2
while :; do
  case $packet_dir in
  /) break ;;
  */) packet_dir=${packet_dir%/} ;;
  */.)
    packet_dir=${packet_dir%/.}
    [[ -n $packet_dir ]] || packet_dir=/
    ;;
  *) break ;;
  esac
done
[[ $number =~ ^[1-9][0-9]*$ ]] || fail "pull-request number must be positive"
[[ -d $packet_dir && ! -L $packet_dir ]] ||
  fail "packet directory must be a real directory, not a symbolic link"
if ! packet_entry=$(find "$packet_dir" -mindepth 1 -maxdepth 1 -print -quit); then
  fail "cannot inspect packet directory contents"
fi
[[ -z $packet_entry ]] || fail "packet directory must be empty"
packet_mode=$(stat -c '%a' -- "$packet_dir" 2>/dev/null ||
  stat -f '%Lp' "$packet_dir") ||
  fail "cannot read packet directory permissions"
[[ $packet_mode =~ ^[0-7]{3,4}$ ]] ||
  fail "packet directory has an invalid permission mode"
(((8#$packet_mode & 8#077) == 0)) ||
  fail "packet directory must be private"
command -v tea >/dev/null 2>&1 || fail "tea is required"
command -v jq >/dev/null 2>&1 || fail "jq is required"
command -v timeout >/dev/null 2>&1 || fail "timeout is required"
umask 077

raw_dir="$packet_dir/forgejo-pages"
mkdir -p -- "$raw_dir"

tea_api() {
  timeout -k 5s "$REQUEST_TIMEOUT" tea api "$@"
}

assert_array() {
  local file=$1 label=$2
  jq -e 'type == "array"' "$file" >/dev/null ||
    fail "$label returned a non-array response"
}

record_page_keys() {
  local file=$1 key_expr=$2 key_type=$3 seen=$4 label=$5
  local keys validation duplicates sort_status uniq_status grep_status
  local -a pipeline_status
  keys="$file.keys"
  duplicates="$file.duplicates"
  case "$key_type" in
  integer)
    validation="($key_expr | if type == \"number\" then floor == . else false end)"
    ;;
  nonempty_string)
    validation="($key_expr | type == \"string\" and length > 0)"
    ;;
  *)
    fail "internal error: unknown stable-key type $key_type"
    ;;
  esac
  jq -e "all(.[]; $validation)" "$file" >/dev/null ||
    fail "$label returned an item without a valid stable key"
  jq -r ".[] | ($key_expr | tostring | @base64)" "$file" >"$keys"
  set +e
  sort "$keys" | uniq -d >"$duplicates"
  pipeline_status=("${PIPESTATUS[@]}")
  set -e
  sort_status=${pipeline_status[0]:-1}
  uniq_status=${pipeline_status[1]:-1}
  ((uniq_status == 0)) ||
    fail "failed to identify duplicate stable keys for $label"
  ((sort_status == 0)) || fail "failed to sort stable keys for $label"
  [[ ! -s $duplicates ]] ||
    fail "pagination made no progress for $label: duplicate key in one page"
  if [[ -s $seen ]]; then
    set +e
    grep -F -x -f "$seen" -- "$keys" >/dev/null
    grep_status=$?
    set -e
    case $grep_status in
    0) fail "pagination made no progress for $label: repeated key" ;;
    1) ;;
    *) fail "failed to compare stable keys for $label" ;;
    esac
  fi
  cat "$keys" >>"$seen"
}

fetch_array_pages() {
  local endpoint=$1 label=$2 key_expr=$3 key_type=$4 output=$5
  local dir="$raw_dir/$label" seen="$raw_dir/$label.seen"
  local page=1 separator page_file count
  mkdir -p -- "$dir"
  : >"$seen"
  case "$endpoint" in *\?*) separator='&' ;; *) separator='?' ;; esac
  while :; do
    ((page <= MAX_PAGES)) ||
      fail "pagination exceeded $MAX_PAGES pages for $label"
    page_file=$(printf '%s/page-%06d.json' "$dir" "$page")
    tea_api "${endpoint}${separator}limit=50&page=$page" >"$page_file"
    assert_array "$page_file" "$label page $page"
    count=$(jq 'length' "$page_file")
    [[ $count -eq 0 ]] && break
    record_page_keys "$page_file" "$key_expr" "$key_type" "$seen" "$label"
    page=$((page + 1))
  done
  jq -s 'add // []' "$dir"/page-*.json >"$output"
}

fetch_status_pages() {
  local endpoint=$1 output=$2
  local dir="$raw_dir/statuses" seen="$raw_dir/statuses.seen"
  local page=1 separator page_file items_file count
  mkdir -p -- "$dir"
  : >"$seen"
  case "$endpoint" in *\?*) separator='&' ;; *) separator='?' ;; esac
  while :; do
    ((page <= MAX_PAGES)) ||
      fail "pagination exceeded $MAX_PAGES pages for statuses"
    page_file=$(printf '%s/raw-%06d.json' "$dir" "$page")
    items_file=$(printf '%s/page-%06d.json' "$dir" "$page")
    tea_api "${endpoint}${separator}limit=50&page=$page" >"$page_file"
    jq -e 'type == "object" and
      (.statuses == null or (.statuses | type == "array"))' \
      "$page_file" >/dev/null ||
      fail "status page $page returned an invalid response"
    jq '.statuses // []' "$page_file" >"$items_file"
    count=$(jq 'length' "$items_file")
    [[ $count -eq 0 ]] && break
    record_page_keys "$items_file" '.id' integer "$seen" "statuses"
    page=$((page + 1))
  done
  jq -s 'add // []' "$dir"/page-*.json >"$output"
}

fetch_array_once() {
  local endpoint=$1 label=$2 output=$3
  tea_api "$endpoint" >"$output"
  assert_array "$output" "$label"
}

tea_api /user >"$packet_dir/reviewer.json"
jq -e 'type == "object" and
  (.login | type == "string" and length > 0)' \
  "$packet_dir/reviewer.json" >/dev/null ||
  fail "authenticated user response is invalid"
reviewer_login=$(jq -r '.login' "$packet_dir/reviewer.json")

tea_api "/repos/{owner}/{repo}/pulls/$number" >"$packet_dir/pr.json"
jq -e 'type == "object" and
  (.head.sha | type == "string" and length > 0) and
  (.base.sha | type == "string" and length > 0) and
  (.user.login | type == "string" and length > 0)' \
  "$packet_dir/pr.json" >/dev/null || fail "pull request response is invalid"
head_oid=$(jq -r '.head.sha' "$packet_dir/pr.json")

fetch_array_pages "/repos/{owner}/{repo}/pulls/$number/reviews" \
  reviews '.id' integer "$packet_dir/reviews.json"
fetch_array_pages "/repos/{owner}/{repo}/pulls/$number/commits?verification=false&files=false" \
  commits '.sha' nonempty_string "$packet_dir/commits.json"
fetch_array_pages "/repos/{owner}/{repo}/pulls/$number/files" \
  files '.filename' nonempty_string "$packet_dir/files.json"
fetch_array_once "/repos/{owner}/{repo}/issues/$number/comments" \
  "issue comments" "$packet_dir/issue-comments.json"
fetch_array_once "/repos/{owner}/{repo}/branch_protections" \
  "branch protections" "$packet_dir/branch-protections.json"
fetch_status_pages "/repos/{owner}/{repo}/commits/$head_oid/status" \
  "$packet_dir/statuses.json"

printf '[]\n' >"$packet_dir/all-review-comments.json"
review_ids_file="$raw_dir/review-ids.txt"
jq -r '.[].id | select(type == "number" and floor == .) | tostring' \
  "$packet_dir/reviews.json" >"$review_ids_file" ||
  fail "failed to extract review identifiers"
while IFS= read -r review_id; do
  comments_file="$raw_dir/review-$review_id-comments.json"
  fetch_array_once \
    "/repos/{owner}/{repo}/pulls/$number/reviews/$review_id/comments" \
    "review $review_id comments" "$comments_file"
  jq -e --argjson id "$review_id" \
    'all(.[]; .pull_request_review_id == $id)' \
    "$comments_file" >/dev/null ||
    fail "review $review_id returned a comment for another review"
  jq -s '.[0] + .[1]' "$packet_dir/all-review-comments.json" \
    "$comments_file" >"$packet_dir/all-review-comments.next.json"
  mv -- "$packet_dir/all-review-comments.next.json" \
    "$packet_dir/all-review-comments.json"
done <"$review_ids_file"

jq --arg login "$reviewer_login" '
  [ .[]
    | select(.user.login? == $login)
    | select(.state == "APPROVED" or
             .state == "REQUEST_CHANGES" or
             .state == "COMMENT")
  ]
  | last // null
' "$packet_dir/reviews.json" >"$packet_dir/previous-review.json"

if jq -e '. != null' "$packet_dir/previous-review.json" >/dev/null; then
  jq -e '(.id | if type == "number" then floor == . else false end) and
    (.submitted_at | type == "string" and length > 0) and
    (.commit_id | type == "string" and length > 0)' \
    "$packet_dir/previous-review.json" >/dev/null ||
    fail "selected prior review has no usable commit identity"
  previous_review_id=$(jq -r '.id' "$packet_dir/previous-review.json")
  jq --argjson id "$previous_review_id" \
    '[.[] | select(.pull_request_review_id == $id)]' \
    "$packet_dir/all-review-comments.json" \
    >"$packet_dir/previous-review-comments.json"
else
  printf '[]\n' >"$packet_dir/previous-review-comments.json"
fi

jq -n \
  --slurpfile review "$packet_dir/previous-review.json" \
  --slurpfile comments "$packet_dir/previous-review-comments.json" '
  if $review[0] == null then
    {mode:"initial", review:null, comments:[],
     thread_resolution:"not_applicable", recheck_all_findings:false}
  else
    {mode:"rereview", review:$review[0], comments:$comments[0],
     thread_resolution:"unknown", recheck_all_findings:true}
  end
' >"$packet_dir/previous-review-context.json"
