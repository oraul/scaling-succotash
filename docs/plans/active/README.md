# Active

Tickets currently being worked on by the Forge pipeline.

Each ticket is a folder. Copy `_template/` to get started.

## Naming

`FRG-XXXX-short-description/`

Example: `FRG-0001-payment-retry/`

## Files

| File | Author | Description |
|---|---|---|
| `brief.md` | Human | Goal, source, and notes for the ticket |
| `contract.md` | Compile | Generated from brief. Source of truth for Draft + Implement |

## Lifecycle

When PR merges → move folder to `shipped/`.
When cancelled → move folder to `archived/`.
