#!/usr/bin/env bash
# frozen_string_literal: true
# Fetch — assembles all context before any LLM runs
# Usage: ./run.sh <ticket_path>
# Example: ./run.sh docs/plans/active/FRG-0001-payment-retry
#
# Produces a bounded .context/ folder. Compile reads from here — no exploration needed.

set -euo pipefail

TICKET_PATH="${1:?Usage: run.sh <ticket_path>}"
OUTPUT_DIR="$TICKET_PATH/.context"

mkdir -p "$OUTPUT_DIR"

echo "==> Fetch started: $TICKET_PATH"

# 1. Brief — the human's goal
echo "  -> brief"
cp "$TICKET_PATH/brief.md" "$OUTPUT_DIR/brief.md"

# 2. Schema — full DB state for Domain Map
echo "  -> schema"
cp db/schema.rb "$OUTPUT_DIR/schema.rb"

# 3. Git history — recent changes to lib/ spec/ db/migrate/
#    Tells Compile what changed recently: migrations, refactors, patterns
echo "  -> git history"
git log --oneline --stat -20 -- lib/ spec/ db/migrate/ > "$OUTPUT_DIR/git_history.txt"

# 4. Agentic specs — what each agent must follow
echo "  -> agentic specs"
cp -r .forge/agentic "$OUTPUT_DIR/agentic"

# 5. Source files — full lib/ for Compile to understand existing patterns
echo "  -> source files"
find lib/ -name "*.rb" -exec cp --parents {} "$OUTPUT_DIR/" \;

# 6. Spec files — full spec/ for Compile to understand test conventions
echo "  -> spec files"
find spec/ -name "*.rb" -exec cp --parents {} "$OUTPUT_DIR/" \;

echo "==> Fetch complete. Context written to $OUTPUT_DIR"
