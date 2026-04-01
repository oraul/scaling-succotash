# Forge — Developer Pipeline

## What This Document Is

This is the design specification for Forge, a developer pipeline system for Ruby codebases. It was designed by studying Stripe's Minions architecture and adapting its patterns to our context. This document should be used as the source of truth when implementing the system.

**Target codebase:** Ruby (Sinatra)
**Testing framework:** RSpec
**Linter:** Rubocop
**LLM provider:** Anthropic (Claude)
**Phase 1 runtime:** Claude CLI
**Future runtime:** Slack invocation + AWS (warm spot instances)

---

## 1. Architecture Philosophy

### Stripe Minions: What We Learned

Stripe's Minions produce 1,300+ PRs/week with zero human-written code. Key patterns adopted:

**1. Deterministic + Agentic node separation.** Blueprints alternate between deterministic steps (no AI — linters, git, CI, file reading) and agentic steps (LLM reasoning — understanding tasks, generating code, interpreting failures). Deterministic nodes constrain what the LLM can do. "The model does not run the system. The system runs the model."

**2. Context pre-hydration.** Before the LLM starts, deterministic code assembles everything the agent needs: ticket content, source files, schema, git history, scoped rules. The agent never explores or searches. It starts with full context.

**3. Devbox execution.** Agents run in isolated, disposable environments — same environments human engineers use.

**4. Toolshed MCP.** Central tool server. Agents get curated subsets per task type.

**5. Bounded retry.** Agents get max 2 CI rounds. After that, bail to human.

**6. Human authority.** Agents have submission authority, not merge authority.

### Core Principle

**Don't build agent infrastructure — build developer infrastructure. Agents inherit it.**

### Key Difference From Minions

Stripe's most unique aspect is the *absence* of a supervisory human mid-pipeline. Forge makes a deliberate opposite choice: humans are checkpoints inside the pipeline — approving the contract before any code is written. This is Phase 1. As confidence in agentic quality grows, these gates are replaced by deterministic scoring. The end state converges toward Minions-level autonomy.

---

## 2. Agent Consolidation

| Original Agent | Verdict | Reasoning |
|---|---|---|
| **Scout** | Killed | Deterministic Fetch replaces it. No AI needed for file discovery. |
| **Diagnose** | Killed | Compile agent handles diagnosis. If specs define expected behavior, failures are self-diagnosing. |
| **Architect** | Merged into Implement | One agent designs AND implements. Splitting causes handoff loss. |
| **TDD** | Became Draft | Writes specs before Implement. Separated because spec quality is critical. |
| **Implement** | Merged with Architect | Combined into single Implement agent. |
| **Refactor** | Killed | Implement should write clean code the first time. |
| **Inspect** | Killed | Deterministic Validate + human PR review replaces AI inspection. |

**Result: 3 agentic steps (Compile + Draft + Implement) + deterministic bookends.**

---

## 3. The Forge Pipeline

### Complete Flowchart

```
[D] Fetch (once)
      │
      ▼
[A] Compile → contract document
      │
      ▼
[D] Assess
      │
      ├── PASS (high confidence) → continue
      └── FAIL (low confidence) → 🚪 Human reviews contract
                                        │
                                        ├── Approve → continue
                                        ├── Reject → ❌
                                        └── Edit → Compile revises → Assess again
            │
            ▼
[A] Draft ◄─────────────────────────────┐
      │                                  │
      ▼                                  │
[A] Implement                            │
      │                                  │
      ▼                                  │
[D] Validate (affected specs + linters)  │
      │                                  │
      ├── PASS → 🚪 Human gate (PR)     │
      │            │                     │
      │            ├── Approve           │
      │            │     │               │
      │            │     ▼               │
      │            │  [D] Verify         │
      │            │     │               │
      │            │     ├── PASS → merge ✅
      │            │     └── FAIL → ─────┘
      │            │                     │
      │            ├── Reject → ❌       │
      │            │                     │
      │            └── Suggestions → ────┘
      │
      └── FAIL
            │
            ▼
      Attempts > 2?
            │
            ├── NO → back to [A] Draft
            │
            └── YES → 🛑 bail to human
                        │
                        ▼
                  human gives guidance → back to [A] Draft
```

### Happy Path

```
[D] Fetch
  → [A] Compile
  → [D] Assess ✅
  → [A] Draft
  → [A] Implement
  → [D] Validate ✅
  → 🚪 Human approves PR
  → [D] Verify ✅
  → merge ✅
```

---

## 4. Pipeline Steps — Detailed

### Step 1: [D] Fetch

**Type:** Deterministic
**Runs:** Once, at pipeline start
**Purpose:** Collect all raw inputs that Compile, Draft, and Implement will need.

**Transport:**

| Source | Transport |
|---|---|
| Files, schema, git history, rule files | Shell script |
| Jira ticket, internal docs | MCP tools (called deterministically — no LLM) |

This is context pre-hydration. Relevant MCP tools are called before any LLM starts.

**What it collects:**

| Input | Source |
|---|---|
| Jira ticket | Jira MCP tool |
| Source files in target area | Codebase |
| Existing specs in target area | `spec/` directory |
| Database schema | `db/schema.rb` |
| Git history for affected files | `git log` on target files |
| Directory-scoped coding rules | `.cursor/rules` or similar |
| Agentic step specs | `.forge/agentic/` |

**Output:** Raw context payload passed to Compile. Everything the pipeline needs, assembled before any AI runs.

---

### Step 2: [A] Compile

**Type:** Agentic
**Spec:** `.forge/agentic/compile.md`
**Purpose:** Read raw Fetch output. Produce the contract document — the single source of truth for all downstream agents.

**Output:** Contract document (markdown) with 6 sections:

1. **Business Rules** — feature requirements translated from product language into precise engineering language
2. **Acceptance Criteria** — concrete, testable conditions that map directly to spec assertions
3. **Domain Map** — models, tables, relationships involved (existing and new)
4. **Technical Concerns** — race conditions, N+1s, caching, transactions, migrations, external dependencies
5. **Constraints** — performance, data volume, backward compatibility
6. **File Targets** — which files to create or modify

---

### Step 3: [D] Assess

**Type:** Deterministic
**Purpose:** Score the contract automatically. Replace the human gate with a quality check. Path to full autonomy.

**Checks:**

| Check | Pass condition |
|---|---|
| Completeness | All 6 sections present |
| Testability | Acceptance criteria are concrete, not vague |
| Schema alignment | Domain map references real tables from Fetch |
| File consistency | File targets exist in the codebase |
| Coverage | Technical concerns address what Fetch flagged |
| Task familiarity | Task type has been seen before (pattern match) |

**On PASS:** Auto-advance to Draft.
**On FAIL:** Human reviews contract → approves / rejects / edits → Compile revises → Assess runs again.

**Autonomy path:**
- Phase 1 — threshold low, humans review often
- Phase 2 — threshold tightens as Compile quality is proven
- Phase 3 — Assess almost never fails, pipeline runs fully unattended

---

### Step 4: [A] Draft

**Type:** Agentic
**Spec:** `.forge/agentic/draft.md`
**Purpose:** Write RSpec tests based on the approved contract. Define what "done" looks like before Implement writes code.

**What it writes:**
- Unit specs — individual classes and methods in isolation
- Integration specs — how services interact, request specs for APIs
- Corner case specs — derived from contract's technical concerns

**Output:** Complete, runnable RSpec files that define expected behavior.

---

### Step 5: [A] Implement

**Type:** Agentic
**Spec:** `.forge/agentic/implement.md`
**Purpose:** Implement the solution. Make all specs pass. Address all technical concerns. Self-review before submitting.

**What it does:**
1. Designs the solution based on the contract's domain map and file targets
2. Implements code to make all specs pass
3. Addresses every technical concern in the contract
4. Respects constraints (performance, data volume, backward compatibility)
5. Self-reviews before submitting

**Output:** Complete implementation files + migrations + config changes that pass all specs.

---

### Step 6: [D] Validate

**Type:** Deterministic (shell script)
**Purpose:** Run affected specs and linters. Fast, cheap check before human sees anything.

**What it runs:**
1. RSpec — specs Draft wrote + existing related specs (affected files only, not full suite)
2. Rubocop — on changed files

**On PASS:** Move to human PR gate.
**On FAIL:** Retry loop (see Section 5).

---

### Step 7: 🚪 Human Gate (PR Review)

**Type:** Human decision point
**Purpose:** Human reviews code and specs in a PR.

- **Approve** — triggers Verify
- **Reject** — pipeline ends
- **Suggestions** — feedback goes back to Draft → Implement → Validate → PR review again

This gate stays permanently. Agents have submission authority, not merge authority.

---

### Step 8: [D] Verify

**Type:** Deterministic (shell script)
**Purpose:** Run the entire test suite + linters. Only after human approval.

**What it runs:**
- Complete RSpec suite
- Complete Rubocop check
- Any other CI checks in the existing pipeline

**On PASS:** Merge. Done. ✅
**On FAIL:** Back to Draft → full pipeline again.

---

## 5. Retry & Bail Rules

Every failure loops back to **Draft** (not Implement alone). The spec might be wrong — garbage in, garbage out. Draft and Implement always work as a pair.

### Validate Failure

```
Attempts > 2?
  ├── NO  → back to Draft
  └── YES → bail to human
              Human sees: original task, attempts 1+2, what still fails, agent's diagnosis
              Human gives guidance → back to Draft with guidance as context
```

### All Loops

| Trigger | Goes back to |
|---|---|
| Validate failure (within 2 attempts) | Draft |
| Validate failure (bail + guidance) | Draft |
| Human PR suggestions | Draft |
| Verify failure | Draft |
| Assess failure (human edits) | Compile |

---

## 6. Agentic Step Specs

Each agentic step has a spec file under `.forge/agentic/`. All files are under 100 lines.

**Structure:**

```markdown
# [step name]

## Purpose
## Always
## Never
## Tools
```

**Rules are simple directives** — `always` and `never` — easy to write, easy for the LLM to follow, easy to audit. If a file grows toward 100 lines, the step is doing too much.

**File structure:**

```
.forge/
  agentic/
    compile.md      < 100 lines
    draft.md        < 100 lines
    implement.md    < 100 lines
```

---

## 7. Terminology

| Term | Meaning |
|---|---|
| **Forge** | The pipeline system |
| **Blueprint** | Pipeline template defining agentic/deterministic node sequence |
| **Deterministic** | Pipeline step with no AI. Shell script or MCP tool called programmatically. Same input → same output. |
| **Agentic** | Pipeline step where Claude reasons and generates. Guided by a spec file. |
| **Fetch** | [D] Collects raw inputs: Jira (MCP), files, schema, git, rule files. Runs once. |
| **Compile** | [A] Reads raw inputs → produces the contract document. |
| **Contract** | Markdown document with 6 sections. Single source of truth for Draft + Implement. |
| **Assess** | [D] Scores the contract against quality checks. Auto-advances or routes to human. |
| **Draft** | [A] Writes RSpec tests from the contract. Follows BetterSpecs standards. |
| **Implement** | [A] Implements code to pass specs. Self-reviews. |
| **Validate** | [D] Runs affected specs + linters. Fast, cheap. |
| **Verify** | [D] Runs entire test suite. Only after human PR approval. |
| **Bail** | Implement failed Validate twice → stops and asks human for guidance. |

---

## 8. Open Questions

| Question | Status | Notes |
|---|---|---|
| Phase 1: Claude CLI invocation | Not started | Define exact command and how context is passed. |
| Assess scoring implementation | Not started | Define pass/fail thresholds and pattern matching for task familiarity. |
| `.forge/agentic/compile.md` content | Not started | Write always/never rules. |
| `.forge/agentic/draft.md` content | Not started | Write always/never rules including BetterSpecs standards. |
| `.forge/agentic/implement.md` content | Not started | Write always/never rules for Ruby/Sinatra conventions. |
| Contract storage location | Done | Each ticket is a folder `FRG-XXXX-short-description/` with `brief.md` (human) and `contract.md` (Compile). Lives in `docs/plans/active/`, moves to `shipped/` on merge or `archived/` on cancellation. |
| MCP tools available in Fetch | Not started | Jira MCP plugin + what else is available. |
| Blueprint specialization | Deferred | One pipeline for now. May add legacy, debug blueprints later. |
| Draft as optional | Deferred | For very simple tasks, Implement might handle specs. Decide based on experience. |
| tasks.md generation | Not started | Who generates tasks.md from contract — Compile (two outputs) or a new pipeline step between Assess and Draft. |
| Warm spot instances vs Lambda | Deferred | Phase 2 (Slack). Spot instances recommended for long-running Claude calls. |
