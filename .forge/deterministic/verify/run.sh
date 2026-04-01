#!/usr/bin/env bash
# frozen_string_literal: true
# Verify — full RSpec suite + full Rubocop
# Usage: ./run.sh
#
# Runs after PR review approval. No partial runs — full codebase must be green.

set -euo pipefail

echo "==> Verify started"

echo "  -> rspec (full suite)"
bundle exec rspec --format progress

echo "  -> rubocop (full codebase)"
bundle exec rubocop

echo "==> Verify complete."
