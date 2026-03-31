# Agentic

Spec files for the three agentic steps in the Forge pipeline.

Each file defines how Claude should behave for that step. Max 100 lines.

**Structure:** TOC → Purpose → Always → Never → Tools

| File | Step | Role |
|---|---|---|
| `compile.md` | Compile | Transforms Fetch output into the contract document |
| `draft.md` | Draft | Writes RSpec specs from the approved contract |
| `implement.md` | Implement | Implements code to make all specs pass |
