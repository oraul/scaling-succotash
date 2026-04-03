# Implement

## Table of Contents
1. [Purpose](#purpose)
2. [Always](#always)
3. [Never](#never)
4. [Tools](#tools)

## Purpose

Read the approved contract and tasks. Implement code that makes every Draft spec
pass. Address every technical concern. Run specs locally before finishing.

**Order of operations:**
1. Read contract.md, tasks.md, and all spec files Draft wrote
2. Create migrations first if Domain Map has new or modified tables
3. Implement in dependency order: models → use cases → routes
4. Run specs after each file — fix immediately if red
5. Self-review checklist before submitting

## Ruby layer responsibilities

**Routes** (`lib/routes/`) — HTTP boundary only:
- Parse request params, call one use case, render JSON response
- Authentication check via helper if required
- No business logic, no DB queries, no conditionals beyond HTTP status

**Use Cases** (`lib/use_cases/`) — all business logic lives here:
- One public entry point: `def self.call(...)` delegating to `new(...).execute`
- Hide all steps (validation, DB writes, side effects) inside `#execute`
- Return a plain result object or raise a typed error — never return raw Sequel datasets

**Models** (`lib/models/`) — data + persistence only:
- Sequel::Model subclass, associations, validations, scopes
- No use case calls, no HTTP concerns

## Always

- Design use cases as deep modules: simple `.call` interface, all complexity inside
- Run `bundle exec rspec <spec_file>` after implementing each file — fix before moving on
- Run `bundle exec rubocop --autocorrect <file>` on every new or modified file
- Follow file targets from contract exactly — no extra files
- Address every technical concern listed in contract section 5
- Check off tasks in `tasks.md` as each file is completed
- Use Sequel only for database interactions
- Add `# frozen_string_literal: true` to every new file
- Use Async for any I/O-bound work
- Call `/create-migration` before writing any migration file

## Never

- Put DB queries or business logic in routes
- Expose use case internals as constructor parameters (shallow interface)
- Call use cases from models or models from use cases (no cross-layer deps)
- Move on to the next file while specs are still failing
- Create files not listed in contract File Targets
- Use raw SQL or ActiveRecord
- Skip a technical concern — state why if genuinely inapplicable
- Modify contract.md or brief.md (tasks.md checkboxes only)

## Self-review checklist

Before finishing, confirm:

- [ ] All specs in tasks.md pass: `bundle exec rspec <spec_files>`
- [ ] No Rubocop offenses on any new file
- [ ] Every route: params → one use case call → JSON response
- [ ] Every use case: one `.call` entry point, complexity hidden in `#execute`
- [ ] Every model: Sequel only, no business rules
- [ ] Every technical concern addressed or explicitly noted

## Tools

- Read: `docs/plans/active/FRG-XXXX/contract.md`
- Read: `docs/plans/active/FRG-XXXX/tasks.md`
- Read: `spec/` — every spec file listed in tasks.md
- Read: `db/schema.rb` — current schema before writing migrations
- Read: existing `lib/` files — understand patterns before adding
- Write: implementation files to paths listed in contract File Targets
- Write: migrations via `/create-migration` skill
- Edit: `tasks.md` checkboxes only
- Shell: `bundle exec rspec <spec_file>` — run after each implementation file
- Shell: `bundle exec rubocop --autocorrect <file>` — lint each file
