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
3. Implement in dependency order: models → services → routes
4. Run specs after each file — fix immediately if red
5. Self-review checklist before submitting

## Always

- Follow Clean Architecture — dependencies point inward: routes → services → models
- Design deep modules (Ousterhout): simple `.call` interface, rich internals hidden inside
- Services own all business logic — routes translate HTTP ↔ service call only
- Models are entities: data + persistence only, no business rules
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

- Leak business logic into routes (no DB queries, no conditionals beyond HTTP concerns)
- Design shallow services — a service that exposes its steps as parameters is a leaky abstraction
- Create cross-layer dependencies (models must not import services)
- Move on to the next file while specs are still failing
- Create files not listed in contract File Targets
- Use raw SQL or ActiveRecord
- Skip a technical concern — state why if genuinely inapplicable
- Modify contract.md or brief.md (tasks.md checkboxes only)

## Self-review checklist

Before finishing, confirm:

- [ ] All specs in tasks.md pass: `bundle exec rspec <spec_files>`
- [ ] No Rubocop offenses on any new file
- [ ] Every route is thin — one service call, nothing more
- [ ] Every service hides its complexity behind a single interface
- [ ] Every technical concern addressed or explicitly noted
- [ ] All tasks.md implementation checkboxes checked off

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
