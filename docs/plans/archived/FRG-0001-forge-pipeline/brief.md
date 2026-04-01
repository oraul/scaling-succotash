# Brief: FRG-0001 — Forge Pipeline Foundation

## Goal

Build the Forge developer pipeline — a Ruby codebase automation system
inspired by Stripe's Minions architecture. Alternates deterministic steps
(shell scripts) and agentic steps (Claude) to produce reviewed, tested
code from a well-defined ticket.

## Scope

- Pipeline: Compile → Plan → Assess → Draft → Implement → Validate → Verify
- Agentic specs for each LLM step (always/never/tools, max 100 lines)
- Deterministic scripts for Assess, Validate, Verify
- Blueprint orchestrator that reads blueprint.yml and runs the pipeline
- Autonomy path: logging, threshold config, Phase 2 readiness criteria

## Readiness Score

| Check | Status |
|---|---|
| Source referenced | ✅ Stripe Minions architecture |
| Business rules precise | ✅ |
| Acceptance criteria testable | ✅ |
| Edge cases addressed | ✅ |
| Uncertainties documented | ✅ |

**Score: 5/5**
