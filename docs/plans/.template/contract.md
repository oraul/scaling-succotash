# Contract: FRG-XXXX — Short Description

## Table of Contents
1. [Source](#1-source)
2. [Business Rules](#2-business-rules)
3. [Acceptance Criteria](#3-acceptance-criteria)
4. [Domain Map](#4-domain-map)
5. [Technical Concerns](#5-technical-concerns)
6. [Constraints](#6-constraints)
7. [File Targets](#7-file-targets)
8. [Insights](#8-insights)
9. [Assess Score](#9-assess-score)
10. [Amendments](#10-amendments)

---

## 1. Source

- **Ticket:** `docs/plans/active/FRG-XXXX/brief.md`
- **Ref:** github.com/oraul/scaling-succotash/issues/NNN
- **Brief score at compile time:** X/5

---

## 2. Business Rules

Refined from brief. Same language, more precise.

- Rule 1
- Rule 2

---

## 3. Acceptance Criteria

Refined from brief. Each maps directly to a spec assertion.

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

Issues Draft and Implement MUST address. If none apply, state why.

- **Concern** — impact and what must be done

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

Compile's assumptions, confidence gaps, and flags. Feeds into Assess.

- **Assumptions** — what Compile assumed when context was ambiguous
- **Confidence** — areas that may be incomplete or uncertain
- **Flags** — anything requiring human attention before approving

---

## 9. Assess Score

Filled by the Assess step. Contract must reach **5/6** to auto-advance.

| Check | Principle | Status | Notes |
|---|---|---|---|
| All sections present and non-empty | Completeness | ❌ | |
| Business rules are precise | Precision | ❌ | |
| Acceptance criteria are testable | Testability | ❌ | |
| Domain map references real schema tables | Traceability | ❌ | |
| Technical concerns addressed or justified | Honesty | ❌ | |
| File targets consistent with codebase | Precision | ❌ | |

**Score: 0/6**

> Decision: (PASS — auto-advance / FAIL — human review required)

---

## 10. Amendments

Revisions after human review at Gate 1.

| Date | Who | Change |
|---|---|---|
| YYYY-MM-DD | Human / Compile | Clarified: ... |
