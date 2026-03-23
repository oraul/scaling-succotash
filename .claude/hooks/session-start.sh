#!/bin/bash
set -euo pipefail

# Only run in remote (Claude Code on the web) environments
if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

cd "$CLAUDE_PROJECT_DIR"

# Bundler 4.x has a CGI bug on Ruby 3.3 — force 2.x
export BUNDLER_VERSION=2.7.2
gem install bundler -v 2.7.2 --no-document 2>/dev/null || true

echo "==> Installing Ruby gems..."
bundle install

# Persist gem bin dir and bundler version for the session
GEM_BINDIR=$(ruby -e 'puts Gem.bindir')
echo "export PATH=\"$GEM_BINDIR:\$PATH\"" >> "$CLAUDE_ENV_FILE"
echo "export BUNDLER_VERSION=2.7.2" >> "$CLAUDE_ENV_FILE"

echo "==> Creating db directory..."
mkdir -p db

echo "==> Session start complete."
