# Forge — Task List

Source of truth: `docs/architecture/forge.md`

---

## 1. Structure

- [x] Create `.forge/agentic/` directory
- [x] Create `.forge/deterministic/` directory
- [x] Define ticket structure — `FRG-XXXX/` folders in `docs/plans/active/`
- [x] Write `docs/plans/.template/brief.md`
- [x] Write `docs/plans/.template/contract.md`
- [x] Write `docs/plans/.template/tasks.md`
- [x] Write `docs/plans/.template/log.md`
- [x] Create `docs/plans/shipped/` and `docs/plans/archived/`
- [x] Write READMEs for all folders

---

## 2. Agentic Specs

Each file: TOC + Purpose + Always + Never + Tools. Max 100 lines.

- [x] Write `.forge/agentic/compile.md`
- [x] Write `.forge/agentic/plan.md`
- [x] Write `.forge/agentic/draft.md`
- [x] Write `.forge/agentic/implement.md`

---

## 3. Blueprint

- [x] Write `.forge/blueprint.yml` — pipeline sequence, routing, gates

---

## 4. Deterministic Steps

Shell scripts. No LLM. Same input → same output.

- [x] Write `.forge/deterministic/assess/run.sh` — scores contract + tasks, outputs PASS/FAIL
- [x] Define Assess pass/fail thresholds (Phase 1: low bar, Phase 2: tighten)
- [x] Implement task familiarity pattern matching for Assess
- [x] Write `.forge/deterministic/validate/run.sh` — RSpec on affected files + Rubocop on changed files
- [x] Write `.forge/deterministic/verify/run.sh` — full RSpec suite + full Rubocop

---

## 5. Blueprint Orchestrator

- [ ] Define Claude CLI invocation pattern for Phase 1
- [ ] Build Blueprint runner — reads `blueprint.yml`, executes steps in sequence
- [ ] Implement retry counter (max 2 attempts before bail)
- [ ] Implement bail output — original task, attempts 1+2, what still fails, agent diagnosis
- [ ] Implement human gate routing (Assess FAIL → human → resume)
- [ ] Implement PR creation on Validate PASS

---

## 6. Autonomy Path

- [ ] Track Assess PASS/FAIL rates per task type
- [ ] Tighten Assess thresholds as Compile quality is proven
- [ ] Document when Phase 2 (Slack + AWS) is ready to begin

---

## 7. Phase 2 (Deferred)

- [ ] Slack invocation — trigger Forge from a Slack thread
- [ ] AWS warm spot instances — replace Claude CLI with cloud runtime
- [ ] Evaluate Blueprint specialization (legacy blueprint, debug blueprint)
- [ ] Evaluate Draft as optional for simple tasks
