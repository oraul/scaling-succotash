# CLAUDE.md

Stack: Ruby 4.0, Sinatra, Sequel, SQLite, Async gem, Falcon, RSpec

## Before Every PR
- `bundle exec rspec`
- `bundle exec rubocop --autocorrect`

## Map
- DB models    → docs/architecture/models.md
- API routes   → docs/architecture/api.md
- Active work  → docs/plans/active/

## Rules
- Sequel only — no raw SQL
- Async for any I/O-bound work
- No logic in routes — use service objects in `lib/services/`
- All files must have `# frozen_string_literal: true`

## Mandatory Skills
- Before creating a migration → call /create-migration
- Before opening a PR        → call /open-pr
