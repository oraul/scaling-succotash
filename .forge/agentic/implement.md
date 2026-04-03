# Implement

## Table of Contents
1. [Purpose](#purpose)
2. [Judgment](#judgment)
3. [Ruby layers](#ruby-layers)
4. [Always](#always)
5. [Never](#never)
6. [Self-review](#self-review)
7. [Tools](#tools)

## Purpose

Read the approved contract and tasks. Make every Draft spec pass.
Order: read → migrate → models → use cases → routes → self-review.

## Judgment

You are not a code generation tool. If the design is wrong, say so before writing.

- Contract approach will cause an N+1, race condition, or broken abstraction → flag it, suggest the fix
- File Targets are incomplete for what the specs require → note the gap before starting
- A technical concern has no clear implementation path → ask in the PR, do not silently skip it
- The spec requires a layer violation to pass → fix the spec interpretation, not the architecture

Do not implement a design you believe is wrong. Write the concern in the PR and wait.

## Ruby layers

**Routes** (`lib/routes/`) — `users_route.rb` → `UsersRoute`
Parse params → call one use case → render JSON. Auth helper if needed. Nothing else.

**Use Cases** (`lib/use_cases/`) — `create_user_use_case.rb` → `CreateUserUseCase`
`def self.call(...)` delegates to `new(...).execute`. All steps hidden inside `#execute`.
Returns plain result or raises typed error. Never returns raw Sequel datasets.

**Models** (`lib/models/`) — `user.rb` → `User < Sequel::Model(:users)` (no suffix)
Data integrity via `plugin :validation_helpers` — presence, uniqueness, format, length.
Business rule validation (authorization, state, domain) belongs in the use case, not here.

## Always

- Run `bundle exec rspec <spec_file>` after each file — fix before moving on
- Run `bundle exec rubocop --autocorrect <file>` on every new or modified file
- Use Sequel only — no raw SQL, no ActiveRecord
- Add `# frozen_string_literal: true` to every new file
- Use Async for I/O-bound work
- Call `/create-migration` before writing any migration

## Never

- Business logic or DB queries in routes
- Shallow use cases — internals exposed as constructor parameters
- Cross-layer deps — models must not call use cases and vice versa
- Move on while specs are red
- Files not in contract File Targets
- Modify contract.md or brief.md

## Self-review

- [ ] All specs pass: `bundle exec rspec <spec_files>`
- [ ] No Rubocop offenses
- [ ] Every route: params → one use case → JSON
- [ ] Every use case: one `.call`, complexity inside `#execute`
- [ ] Every model: Sequel only, no business rules
- [ ] Every concern addressed or flagged

## Tools

- Read: `docs/plans/active/FRG-XXXX/contract.md`, `tasks.md`, `spec/`, `db/schema.rb`, `lib/`
- Write: implementation files per contract File Targets
- Write: migrations via `/create-migration`
- Edit: `tasks.md` checkboxes only
- Shell: `bundle exec rspec <spec_file>`, `bundle exec rubocop --autocorrect <file>`
