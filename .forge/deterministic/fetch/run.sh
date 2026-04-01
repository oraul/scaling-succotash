#!/usr/bin/env bash
# frozen_string_literal: true
# Fetch — collects all context before any LLM runs
# Usage: ./run.sh <ticket_path>
# Example: ./run.sh docs/plans/active/FRG-0001-payment-retry

set -euo pipefail

TICKET_PATH="${1:?Usage: run.sh <ticket_path>}"
OUTPUT_DIR="$TICKET_PATH/.context"

mkdir -p "$OUTPUT_DIR"

echo "==> Fetch started: $TICKET_PATH"

# 1. Brief
echo "  -> brief"
cp "$TICKET_PATH/brief.md" "$OUTPUT_DIR/brief.md"

# 2. Schema
echo "  -> schema"
cp db/schema.rb "$OUTPUT_DIR/schema.rb"

# 3. Git history for files in lib/ and spec/
echo "  -> git history"
git log --oneline -20 -- lib/ spec/ > "$OUTPUT_DIR/git_history.txt"

# 4. Agentic specs
echo "  -> agentic specs"
cp -r .forge/agentic "$OUTPUT_DIR/agentic"

# 5. Source files — all lib/ files
echo "  -> source files"
mkdir -p "$OUTPUT_DIR/lib"
find lib/ -name "*.rb" -exec cp --parents {} "$OUTPUT_DIR/" \;

# 6. Existing specs
echo "  -> existing specs"
mkdir -p "$OUTPUT_DIR/spec"
find spec/ -name "*.rb" -exec cp --parents {} "$OUTPUT_DIR/" \;

echo "==> Fetch complete. Context written to $OUTPUT_DIR"
