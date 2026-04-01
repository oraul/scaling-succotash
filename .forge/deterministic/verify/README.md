# Verify

Runs the full test suite + linters. Only after human PR approval. Expensive — runs once.

## Tools

| Tool | Transport | Purpose |
|---|---|---|
| RSpec | Shell | Full suite — all specs, not just affected |
| Rubocop | Shell | Full codebase lint check |

## Output

PASS → merge ✅
FAIL → back to Draft, full pipeline again.
