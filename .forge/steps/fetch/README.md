# Fetch

Collects all context before any LLM runs. No AI involved.

## Tools

| Tool | Transport | Purpose |
|---|---|---|
| File reader | Shell | Source files, schema, git history, rule files, agentic specs |
| Ticket reader | Shell | `docs/plans/active/FRG-XXXX/brief.md` |

## Output

Raw context payload passed to Compile. Everything the pipeline needs, assembled once.
