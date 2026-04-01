#!/usr/bin/env bash
# frozen_string_literal: true
# Validate — RSpec on affected spec files + Rubocop on changed source files
# Usage: ./run.sh <ticket_path>
# Example: ./run.sh docs/plans/active/FRG-0001-payment-retry
#
# Runs only the files touched by this ticket — fast feedback loop.
# Full suite runs in Verify.

set -euo pipefail

TICKET_PATH="${1:?Usage: run.sh <ticket_path>}"
TASKS="$TICKET_PATH/tasks.md"

echo "==> Validate started: $TICKET_PATH"

# ── Collect spec files from tasks.md ────────────────────────────────────────
spec_files=()
while IFS= read -r line; do
  file=$(echo "$line" | grep -oE 'spec/[^ ]+_spec\.rb')
  if [ -n "$file" ] && [ -f "$file" ]; then
    spec_files+=("$file")
  fi
done < <(grep -E "spec/.*_spec\.rb" "$TASKS")

# ── Collect source files from tasks.md ──────────────────────────────────────
source_files=()
while IFS= read -r line; do
  file=$(echo "$line" | grep -oE '(lib|db)/[^ ]+\.rb')
  if [ -n "$file" ] && [ -f "$file" ]; then
    source_files+=("$file")
  fi
done < <(grep -E '\- \[.\] (lib|db)/' "$TASKS")

# ── RSpec ────────────────────────────────────────────────────────────────────
if [ "${#spec_files[@]}" -eq 0 ]; then
  echo "  [warn] No spec files found in tasks.md — skipping RSpec"
else
  echo "  -> rspec (${#spec_files[@]} file(s))"
  bundle exec rspec "${spec_files[@]}" --format progress
fi

# ── Rubocop ─────────────────────────────────────────────────────────────────
if [ "${#source_files[@]}" -eq 0 ]; then
  echo "  [warn] No source files found in tasks.md — skipping Rubocop"
else
  echo "  -> rubocop (${#source_files[@]} file(s))"
  bundle exec rubocop "${source_files[@]}"
fi

echo "==> Validate complete."
