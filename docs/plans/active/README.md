# Active

Tickets currently being worked on by the Forge pipeline.

Each ticket is a folder. Copy `docs/plans/.template/` to get started.

## Naming

`FRG-XXXX-short-description/`

Example: `FRG-0001-payment-retry/`

## Files

| File | Author | Description |
|---|---|---|
| `brief.md` | Human | Goal, source, and notes. **Immutable after readiness 4/5** |
| `contract.md` | Compile | Source of truth for Draft + Implement. **Immutable after Assess PASS** |
| `tasks.md` | Plan | Checklist. **Only checkboxes can change** |
| `log.md` | Pipeline | Human feedback, guidance, and bail notes throughout the run |

## Lifecycle

When PR merges → move folder to `shipped/`.
When cancelled → move folder to `archived/`.
