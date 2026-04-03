# Forge

Developer pipeline for Ruby codebases. Inspired by Stripe's Minions architecture.
Alternates between deterministic steps (scripts) and agentic steps (Claude) to
produce reviewed, tested, merged code from a well-defined ticket.

## Pipeline

```
[A] Compile ──→ contract.md
     │
     ▼
[A] Plan ──→ tasks.md
     │
     ▼
[A] Judge ──→ contract Insights
     │
     ▼
[D] Assess
     ├── PASS ──→ continue
     └── FAIL ──→ 🚪 human reviews contract + tasks
     │
     ▼
[A] Draft ──→ spec files
     │
     ▼
[A] Implement ──→ implementation files
     │
     ▼
[D] Validate
     ├── PASS ──→ 🚪 human reviews PR
     └── FAIL ──→ retry (max 2) or bail to human
     │
     ▼
[D] Verify
     ├── PASS ──→ merge ✅
     └── FAIL ──→ back to Draft
```

## Steps

| Step | Type | Description |
|---|---|---|
| **Compile** | Agentic | Reads brief, schema, lib/, spec/ directly → produces `contract.md`. Single source of truth for the full pipeline. |
| **Plan** | Agentic | Reads contract → produces `tasks.md`. Structured checklist for Draft and Implement. |
| **Judge** | Agentic | Reviews contract + tasks for design issues — N+1s, race conditions, layer violations. Writes findings to contract Insights. Human decides at Assess gate. |
| **Assess** | Deterministic | Scores contract + tasks against quality checks. PASS auto-advances. FAIL routes to human review of both. |
| **Draft** | Agentic | Writes RSpec specs from the contract. Defines done before any code is written. |
| **Implement** | Agentic | Implements code to make all specs pass. Self-reviews before submitting. |
| **Validate** | Deterministic | Runs affected specs + Rubocop on changed files. Fast, cheap. Max 2 retries before bail. |
| **Verify** | Deterministic | Runs full RSpec suite + Rubocop. Only after human PR approval. |

## Key Principles

- **Deterministic steps are scripts** — no LLM, same output every time
- **Agentic steps are guided by specs** — see `agentic/` for always/never rules
- **The model does not run the system — the system runs the model**
- **Agents have submission authority, not merge authority**

## Structure

```
.forge/
  README.md          ← you are here
  blueprint.yml      ← pipeline definition (step sequence, routing, gates)
  agentic/
    README.md        ← how to write agentic specs
    compile.md
    plan.md
    judge.md
    draft.md
    implement.md
  deterministic/
    assess/          ← contract + tasks scorer
    validate/        ← RSpec (affected) + Rubocop (changed)
    verify/          ← full RSpec + Rubocop
```

## Ticket Lifecycle

```
docs/plans/active/FRG-XXXX/    ← in progress
  brief.md                     ← immutable after readiness 4/5
  contract.md                  ← immutable after Assess PASS
  tasks.md                     ← only checkboxes can change
  log.md                       ← human feedback, guidance, bail notes

docs/plans/shipped/FRG-XXXX/   ← PR merged
docs/plans/archived/FRG-XXXX/  ← cancelled or abandoned
```
