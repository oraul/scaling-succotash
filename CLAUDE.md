# CLAUDE.md

Stack: Ruby >= 3.3, Sinatra, Sequel, SQLite, Async gem, Falcon, RSpec

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
- No logic in routes — use use cases in `lib/use_cases/` (suffix: `_use_case.rb`)
- File naming follows folder suffix: `_use_case.rb`, `_route.rb` — models are the exception: `user.rb` → `User`
- All files must have `# frozen_string_literal: true`
- Never expose private URLs (session links, internal endpoints, tokens) in commit messages, comments, or any tracked file
- All environment variables must be configured as GitHub secrets — never hardcode values in `render.yaml`, workflows, or any committed file

## Mandatory Skills
- Before creating a migration → call /create-migration
- Before opening a PR        → call /manage-pr
