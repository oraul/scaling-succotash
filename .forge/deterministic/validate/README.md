# Validate

Runs affected specs + linters on changed files. Fast, cheap. Max 2 retries.

## Tools

| Tool | Transport | Purpose |
|---|---|---|
| RSpec | Shell | Runs specs Draft wrote + existing related specs (affected files only) |
| Rubocop | Shell | Lints changed files only |

## Retry Rules

- Attempt 1 fails → back to Draft
- Attempt 2 fails → bail to human
- Human gives guidance → stored in contract Amendments → back to Draft

## Output

PASS → PR review gate.
FAIL → retry or bail.
