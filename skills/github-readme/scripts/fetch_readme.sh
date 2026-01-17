#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage: fetch_readme.sh <owner/repo> [ref]

Fetch a repository README via GitHub API using gh CLI.
- Searches root for README.* (case-insensitive)
- Falls back to recursive search if not found in root
- Prints README contents to stdout
USAGE
}

if [[ ${#} -lt 1 ]]; then
  usage
  exit 1
fi

repo="$1"
ref="${2:-}"
api_base="repos/${repo}"

ref_args=()
if [[ -n "$ref" ]]; then
  ref_args=(-f "ref=${ref}")
fi

find_in_root() {
  gh api "${api_base}/contents" "${ref_args[@]}" \
    --jq '.[]
      | select(.type=="file")
      | select(.name | test("(?i)^readme(\\..+)?$"))
      | .path' \
    | head -n 1
}

find_recursive() {
  gh api "${api_base}/git/trees/${ref:-HEAD}" -f recursive=1 \
    --jq '[.tree[]
      | select(.type=="blob")
      | select(.path | test("(?i)(^|/)readme(\\..+)?$"))]
      | sort_by(.path | length)
      | .[0].path // empty'
}

path="$(find_in_root)"
if [[ -z "$path" ]]; then
  path="$(find_recursive)"
fi

if [[ -z "$path" ]]; then
  echo "No README found in ${repo}" >&2
  exit 2
fi

# Fetch raw content
exec gh api "${api_base}/contents/${path}" \
  -H "Accept: application/vnd.github.raw" \
  "${ref_args[@]}"
