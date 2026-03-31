# Contract: FRG-NNN-short-description

## 1. Business Rules

What the feature must do. Requirements translated from ticket language into precise
engineering statements. No product jargon.

- Rule 1
- Rule 2

## 2. Acceptance Criteria

Concrete, testable conditions. Each maps directly to a spec assertion.

- When X, then Y
- When X is missing, then Z

## 3. Domain Map

Models, tables, relationships, columns, and indexes involved.

**Existing:**
- `ModelName` → `table_name`
  - columns: id, ...
  - associations: belongs_to, has_many, ...

**New / Modified:**
- `ModelName` (new) → `table_name`
  - columns: id, ...
  - indexes: ...

## 4. Technical Concerns

Issues agents MUST address. If none apply, state why.

- **Race conditions** — ...
- **N+1 queries** — ...
- **Transaction boundaries** — ...
- **Migrations** — ...
- **External dependencies** — ...

## 5. Constraints

Non-functional requirements.

- **Performance** — ...
- **Data volume** — ...
- **Backward compatibility** — ...

## 6. File Targets

**New files:**
- `path/to/file.rb`

**Modified files:**
- `path/to/existing.rb` — reason

## 7. Insights

Key assumptions made, areas of uncertainty, and anything requiring human attention.
Feeds directly into the Assess scoring step.

- **Assumptions** — what Compile assumed when context was ambiguous
- **Confidence** — areas where the contract may be incomplete or uncertain
- **Flags** — anything a human should pay close attention to before approving
