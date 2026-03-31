# Contract: FRG-NNN-short-description

## Table of Contents
1. [Source](#1-source)
2. [Business Rules](#2-business-rules)
3. [Acceptance Criteria](#3-acceptance-criteria)
4. [Domain Map](#4-domain-map)
5. [Technical Concerns](#5-technical-concerns)
6. [Constraints](#6-constraints)
7. [File Targets](#7-file-targets)
8. [Insights](#8-insights)
9. [Amendments](#9-amendments)

---

## 1. Source

Traceability back to the original request.

- **Ticket:** `docs/plans/active/FRG-NNN-short-description.md`
- **Ref:** github.com/oraul/scaling-succotash/issues/NNN
- **Original comment:** (paste or summarize what triggered this work)

---

## 2. Business Rules

What the feature must do. Translated from ticket language into precise engineering
statements. No product jargon.

- Rule 1
- Rule 2

---

## 3. Acceptance Criteria

Concrete, testable conditions. Each maps directly to a spec assertion.

- When X, then Y
- When X is missing, then Z

---

## 4. Domain Map

Models, tables, relationships, columns, and indexes involved.

**Existing:**
- `ModelName` → `table_name`
  - columns: id, ...
  - associations: belongs_to, has_many, ...

**New / Modified:**
- `ModelName` (new) → `table_name`
  - columns: id, ...
  - indexes: ...

---

## 5. Technical Concerns

Issues agents MUST address. If none apply, state why.

- **Race conditions** — ...
- **N+1 queries** — ...
- **Transaction boundaries** — ...
- **Migrations** — ...
- **External dependencies** — ...

---

## 6. Constraints

Non-functional requirements.

- **Performance** — ...
- **Data volume** — ...
- **Backward compatibility** — ...

---

## 7. File Targets

**New files:**
- `path/to/file.rb`

**Modified files:**
- `path/to/existing.rb` — reason

---

## 8. Insights

Key assumptions, confidence gaps, and flags for human review.
Feeds into Assess scoring.

- **Assumptions** — what Compile assumed when context was ambiguous
- **Confidence** — areas where the contract may be incomplete or uncertain
- **Flags** — anything a human should pay close attention to before approving

---

## 9. Amendments

Revisions made after human review at Gate 1. Each entry dated.

| Date | Change |
|---|---|
| YYYY-MM-DD | Human clarified: ... |
