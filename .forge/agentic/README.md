# Agentic

Spec files for the three agentic steps in the Forge pipeline.

Each file defines how Claude should behave for that step. Max 100 lines.

**Structure:** TOC → Purpose → Always → Never → Tools

## Rules for writing a spec

**Language**
- Use imperative, one line per rule: `Always X`, `Never Y`
- No explanations, no reasoning, no examples inside the file — directives only

**Purpose**
- One paragraph max
- What the step does and what it outputs — not how it does it

**Always / Never**
- Keep each list under 10 rules
- More than 10 means the step is doing too much — split it

**Tools**
- List only what this step actually uses
- Not all available tools — only the relevant subset

**Scope**
- One file per step, one concern per file
- If the file grows past 100 lines, the step is overloaded — simplify or split

## Steps

| File | Step | Role |
|---|---|---|
| `compile.md` | Compile | Transforms Fetch output into the contract document |
| `plan.md` | Plan | Reads contract → produces tasks.md checklist |
| `draft.md` | Draft | Writes RSpec specs from the approved contract |
| `implement.md` | Implement | Implements code to make all specs pass |
