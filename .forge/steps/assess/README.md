# Assess

Scores contract + tasks deterministically. No AI involved.

## Tools

| Tool | Transport | Purpose |
|---|---|---|
| Contract reader | Shell | Reads `contract.md` for section checks |
| Tasks reader | Shell | Reads `tasks.md` for completeness checks |
| Schema reader | Shell | Validates Domain Map against real tables |

## Checks

| Check | Principle |
|---|---|
| All contract sections present and non-empty | Completeness |
| Business rules are precise | Precision |
| Acceptance criteria are testable | Testability |
| Domain map references real schema tables | Traceability |
| Technical concerns addressed or justified | Honesty |
| File targets consistent with codebase | Precision |
| Tasks derived from contract file targets | Completeness |

## Output

PASS → auto-advance to Draft.
FAIL → human reviews contract + tasks. Guidance stored in contract Amendments.
