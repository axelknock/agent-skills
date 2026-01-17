#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage: fetch_pr_discussion.sh [<pr-number>|<branch>]

Fetch PR discussion (issue comments, review comments, reviews) using gh api.
Defaults to the current branch if no argument is provided.
USAGE
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

input="${1:-}"
repo=$(gh repo view --json nameWithOwner --jq '.nameWithOwner')
owner=$(gh repo view --json owner --jq '.owner.login')

if [[ -z "$input" ]]; then
  branch=$(git rev-parse --abbrev-ref HEAD)
elif [[ "$input" =~ ^[0-9]+$ ]]; then
  pr_number="$input"
else
  branch="$input"
fi

if [[ -z "${pr_number:-}" ]]; then
  pr_number=$(gh api "repos/$repo/pulls" -f head="$owner:$branch" -f state=all --jq '.[0].number')
fi

if [[ -z "${pr_number:-}" || "$pr_number" == "null" ]]; then
  echo "No PR found for ${branch:-input}." >&2
  exit 1
fi

tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT

gh api "repos/$repo/pulls/$pr_number" > "$tmpdir/pr.json"
gh api "repos/$repo/issues/$pr_number/comments" > "$tmpdir/issue_comments.json"
gh api "repos/$repo/pulls/$pr_number/comments" > "$tmpdir/review_comments.json"
gh api "repos/$repo/pulls/$pr_number/reviews" > "$tmpdir/reviews.json"

jq -n \
  --arg repo "$repo" \
  --argjson pr_number "$pr_number" \
  --slurpfile pr "$tmpdir/pr.json" \
  --slurpfile issue_comments "$tmpdir/issue_comments.json" \
  --slurpfile review_comments "$tmpdir/review_comments.json" \
  --slurpfile reviews "$tmpdir/reviews.json" \
  '{repo: $repo, pr_number: $pr_number, pr: $pr[0], issue_comments: $issue_comments[0], review_comments: $review_comments[0], reviews: $reviews[0]}'
