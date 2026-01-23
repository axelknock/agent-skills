#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage: fetch_readme.sh [--subdir <path>] [--file <filename>] <owner/repo> [ref]

Fetch a repository README (or a specific file) via GitHub API using gh CLI.
- Default: search for README.(md|org|txt) in the repo root, then recursively
- --subdir: limit the search to a subdirectory (search that directory first, then recursively within it)
- --file / --filename: fetch an exact filename (case-insensitive), combined with optional --subdir
- Prints file contents to stdout
USAGE
}

subdir=""
filename=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --subdir)
      if [[ $# -lt 2 ]]; then
        echo "Missing value for --subdir" >&2
        usage
        exit 1
      fi
      subdir="$2"
      shift 2
      ;;
    --file|--filename)
      if [[ $# -lt 2 ]]; then
        echo "Missing value for $1" >&2
        usage
        exit 1
      fi
      filename="$2"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    --)
      shift
      break
      ;;
    -*)
      echo "Unknown option: $1" >&2
      usage
      exit 1
      ;;
    *)
      break
      ;;
  esac

done

if [[ $# -lt 1 ]]; then
  usage
  exit 1
fi

repo="$1"
ref="${2:-}"
api_base="repos/${repo}"

if [[ "$subdir" == "." ]]; then
  subdir=""
fi
subdir="${subdir#/}"
subdir="${subdir%/}"

ref_args=()
if [[ -n "$ref" ]]; then
  ref_args=(-f "ref=${ref}")
fi

jq_args=(--arg filename "$filename" --arg subdir "$subdir")

find_in_dir() {
  local dir_path="$1"
  gh api "${api_base}/contents${dir_path:+/${dir_path}}" "${ref_args[@]}" \
    "${jq_args[@]}" \
    --jq '.[]
      | select(.type=="file")
      | select(
          if ($filename|length) > 0 then
            (.name | ascii_downcase) == ($filename | ascii_downcase)
          else
            (.name | test("(?i)^readme(\\.(md|org|txt))?$"))
          end
        )
      | .path' \
    | head -n 1
}

find_recursive() {
  gh api "${api_base}/git/trees/${ref:-HEAD}" -f recursive=1 \
    "${jq_args[@]}" \
    --jq '[.tree[]
      | select(.type=="blob")
      | select(
          (if ($subdir|length) > 0 then (.path | startswith($subdir + "/")) else true end)
          and
          (if ($filename|length) > 0 then
            (.path | split("/") | last | ascii_downcase) == ($filename | ascii_downcase)
          else
            (.path | test("(?i)(^|/)readme(\\.(md|org|txt))?$"))
          end)
        )
      ]
      | sort_by(.path | length)
      | .[0].path // empty'
}

path="$(find_in_dir "$subdir")"
if [[ -z "$path" ]]; then
  path="$(find_recursive)"
fi

if [[ -z "$path" ]]; then
  if [[ -n "$subdir" ]]; then
    echo "No matching file found in ${repo} under ${subdir}" >&2
  else
    echo "No matching file found in ${repo}" >&2
  fi
  exit 2
fi

exec gh api "${api_base}/contents/${path}" \
  -H "Accept: application/vnd.github.raw" \
  "${ref_args[@]}"
