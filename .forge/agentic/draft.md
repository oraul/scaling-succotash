# Draft

## Table of Contents
1. [Purpose](#purpose)
2. [Always](#always)
3. [Never](#never)
4. [Tools](#tools)

## Purpose

Read the approved contract from `.forge/contracts/` and write RSpec specs that
define what "done" looks like. Implement writes code to make these pass.

## Always

- Map every acceptance criteria to at least one spec assertion
- Map every technical concern to a corner case spec
- Use `describe '.method'` for class methods, `describe '#method'` for instance methods
- Start `context` blocks with "when" — always include the negative case
- Use `let` for setup, never instance variables in `before`
- Use `expect` syntax only
- Use FactoryBot factories, never fixtures
- Use request specs for API endpoints, not controller specs
- Keep each `it` block to exactly one assertion
- Follow existing spec patterns in the codebase (naming, helpers, shared examples)

## Never

- Write specs that are not grounded in the contract's acceptance criteria
- Use `should` syntax
- Leave technical concerns untested (race conditions, N+1s, edge cases)
- Write fixtures — always factories
- Test multiple behaviours in one `it` block

## Tools

- Read: contract from `.forge/contracts/`
- Read: existing specs from `spec/` — for patterns and conventions
- Read: source files from Fetch context
- Write: spec files to `spec/`
