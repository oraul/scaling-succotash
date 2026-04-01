#!/usr/bin/env bash
# frozen_string_literal: true
# Fetch — generates context that doesn't exist yet before any LLM runs
# Usage: ./run.sh <ticket_path>
# Example: ./run.sh docs/plans/active/FRG-0001-payment-retry
#
# Does NOT copy files that already exist in the repo.
# Compile reads schema, lib/, spec/ directly via its Tools section.

set -euo pipefail

TICKET_PATH="${1:?Usage: run.sh <ticket_path>}"

echo "==> Fetch started: $TICKET_PATH"

# Git history — recent changes to lib/, spec/, db/migrate/
# Tells Compile what changed recently: migrations, refactors, patterns in context
echo "  -> git history"
git log --oneline --stat -20 -- lib/ spec/ db/migrate/ > "$TICKET_PATH/git_history.txt"

echo "==> Fetch complete."
