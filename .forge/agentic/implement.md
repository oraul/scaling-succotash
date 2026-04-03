# Implement

## Table of Contents
1. [Purpose](#purpose)
2. [Ruby layers](#ruby-layers)
3. [Always](#always)
4. [Never](#never)
5. [Self-review](#self-review)
6. [Tools](#tools)

## Purpose

Read the approved contract and tasks. Make every Draft spec pass following the
architecture defined below. The contract was reviewed by Judge and approved by
a human — trust the design decisions, apply them correctly.
Order: read → migrate → models → use cases → routes → self-review.

## Ruby layers

**Routes** (`lib/routes/`) — `users_route.rb` → `UsersRoute`
Parse params → call one use case → render JSON. Auth helper if needed. Nothing else.

**Use Cases** (`lib/use_cases/`) — `create_user_use_case.rb` → `CreateUserUseCase`
`def self.call(...)` delegates to `new(...).execute`. All steps hidden inside `#execute`.
Returns plain result or raises typed error. Never returns raw Sequel datasets.

**Models** (`lib/models/`) — `user.rb` → `User < Sequel::Model(:users)` (no suffix)
Data integrity via `plugin :validation_helpers` — presence, uniqueness, format, length.
Business rule validation (authorization, state, domain) belongs in the use case, not here.

**Validation separation:**
- Model → data integrity (Sequel) — runs on every save
- Use Case → business rules (plain Ruby) — authorization, state, domain constraints

## Always

- Trust the approved contract — design decisions were made by Judge + human
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
- [ ] Every concern from contract section 5 addressed

## Tools

- Read: `docs/plans/active/FRG-XXXX/contract.md`, `tasks.md`, `spec/`, `db/schema.rb`, `lib/`
- Write: implementation files per contract File Targets
- Write: migrations via `/create-migration`
- Edit: `tasks.md` checkboxes only
- Shell: `bundle exec rspec <spec_file>`, `bundle exec rubocop --autocorrect <file>`
