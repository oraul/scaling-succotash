#!/usr/bin/env bash
# frozen_string_literal: true
# Fetch — captures recent git history before any LLM runs
# Usage: ./run.sh <ticket_path>
# Example: ./run.sh docs/plans/active/FRG-0001-payment-retry

set -euo pipefail

TICKET_PATH="${1:?Usage: run.sh <ticket_path>}"
OUTPUT="$TICKET_PATH/git_history.txt"

echo "==> Fetch started: $TICKET_PATH"

# Git history for lib/ and spec/ — temporal context for Compile
# Tells the agent what changed recently: recent migrations, refactors, patterns
git log --oneline --stat -20 -- lib/ spec/ db/migrate/ > "$OUTPUT"

echo "  -> git history written to $OUTPUT"
echo "==> Fetch complete."
