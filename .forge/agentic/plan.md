# Plan

## Table of Contents
1. [Purpose](#purpose)
2. [Always](#always)
3. [Never](#never)
4. [Tools](#tools)

## Purpose

Read the approved contract and produce `tasks.md` — a structured checklist of
everything Draft and Implement must do. One source of progress for the full ticket.

## Always

- Derive spec tasks directly from contract Acceptance Criteria and File Targets
- Derive implementation tasks directly from contract File Targets
- Derive concern tasks from every item in contract Technical Concerns
- Name files exactly as they will exist in the codebase
- Add migration tasks when Domain Map has new or modified tables
- Keep tasks atomic — one file or one concern per checkbox

## Never

- Invent tasks not grounded in the contract
- Group multiple files into one checkbox
- Skip Technical Concerns — every concern becomes a task
- Add tasks that belong to deterministic steps (Validate, Verify are not tasks)

## Tools

- Read: contract from `docs/plans/active/FRG-XXXX/contract.md`
- Write: tasks to `docs/plans/active/FRG-XXXX/tasks.md` using `docs/plans/.template/tasks.md`
