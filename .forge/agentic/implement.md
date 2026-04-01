# Implement

## Table of Contents
1. [Purpose](#purpose)
2. [Always](#always)
3. [Never](#never)
4. [Tools](#tools)

## Purpose

Read the contract and tasks. Write code that makes all Draft specs pass.
Address every technical concern. Self-review before finishing.

## Always

- Make every spec Draft wrote pass before finishing
- Follow file targets from contract exactly — no extra files
- Address every technical concern listed in the contract
- Check off tasks in tasks.md as each file is completed
- Use Sequel only for database interactions
- Use service objects in `lib/services/` for business logic
- Add `# frozen_string_literal: true` to every new file
- Use Async for any I/O-bound work
- Create migrations when Domain Map has new or modified tables
- Self-review: read your own output before finishing

## Never

- Create files not listed in contract File Targets
- Put business logic in routes
- Use raw SQL or ActiveRecord
- Skip a technical concern — each one must be handled
- Modify contract.md, brief.md, or tasks.md content (checkboxes only)
- Submit without running a mental pass over the implementation

## Tools

- Read: contract from `docs/plans/active/FRG-XXXX/contract.md`
- Read: tasks from `docs/plans/active/FRG-XXXX/tasks.md`
- Read: spec files from `spec/` — understand what must pass
- Read: existing source files from Fetch context
- Write: implementation files to their target paths
- Write: migrations to `db/migrate/`
- Edit: `tasks.md` checkboxes only
