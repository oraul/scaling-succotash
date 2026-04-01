# Forge — Task List

Source of truth: `docs/architecture/forge.md`

---

## 1. Structure

- [x] Create `.forge/agentic/` directory
- [x] Create `.forge/contracts/` directory (contract storage)
- [x] Define ticket naming convention — `FRG-XXXX-short-description/` folders in `docs/plans/active/`, moved to `docs/plans/shipped/` when PR merges
- [x] Write `docs/plans/.template/brief.md` — human-written ticket template
- [x] Write `docs/plans/.template/contract.md` — defines the 9 contract sections including Insights and Amendments

---

## 2. Agentic Specs

Each file: TOC + Purpose + Always + Never + Tools. Max 100 lines.

- [x] Write `.forge/agentic/compile.md`
- [x] Write `.forge/agentic/plan.md`
- [x] Write `.forge/agentic/draft.md` (include BetterSpecs always/never rules)
- [x] Write `.forge/agentic/implement.md` (include Ruby/Sinatra always/never rules)

---

## 3. Deterministic Steps

Shell scripts. No LLM. Same input → same output.

- [ ] Write `Fetch` script — reads files, schema (`db/schema.rb`), git history, rule files
- [ ] Fetch reads ticket from `docs/plans/active/` (no Jira for now)
- [ ] Audit which MCP tools are available for Fetch (future Jira integration)
- [ ] Write `Assess` script — scores contract against 6 checks, outputs PASS/FAIL
- [ ] Define Assess pass/fail thresholds (Phase 1: low bar, Phase 2: tighten)
- [ ] Implement task familiarity pattern matching for Assess
- [ ] Write `Validate` script — RSpec on affected files + Rubocop on changed files
- [ ] Write `Verify` script — full RSpec suite + full Rubocop

---

## 4. Blueprint Orchestrator

The thing that runs the pipeline in sequence.

- [ ] Define Claude CLI invocation pattern for Phase 1 (exact command + how context is passed)
- [ ] Build Blueprint runner — executes Fetch → Compile → Assess → Draft → Implement → Validate → Verify in order
- [ ] Implement retry counter (max 2 attempts before bail)
- [ ] Implement bail output — original task, attempts 1+2, what still fails, agent diagnosis
- [ ] Implement human gate routing (Assess FAIL → human → resume)
- [ ] Implement PR creation on Validate PASS

---

## 5. Autonomy Path

- [ ] Track Assess PASS/FAIL rates per task type
- [ ] Tighten Assess thresholds as Compile quality is proven
- [ ] Document when Phase 2 (Slack + AWS) is ready to begin

---

## 6. Phase 2 (Deferred)

- [ ] Slack invocation — trigger Forge from a Slack thread
- [ ] AWS warm spot instances — replace Claude CLI with cloud runtime
- [ ] Evaluate Blueprint specialization (legacy blueprint, debug blueprint)
- [ ] Evaluate Draft as optional for simple tasks
