#!/usr/bin/env bash
# frozen_string_literal: true
# Assess — scores contract.md + tasks.md, outputs PASS/FAIL
# Usage: ./run.sh <ticket_path>
# Example: ./run.sh docs/plans/active/FRG-0001-payment-retry
#
# PASS threshold: 5/6 (Phase 1 — tighten in Phase 2)
# FAIL → human gate (assess-edit or assess-reject)

set -euo pipefail

TICKET_PATH="${1:?Usage: run.sh <ticket_path>}"
CONTRACT="$TICKET_PATH/contract.md"
TASKS="$TICKET_PATH/tasks.md"
SCHEMA="db/schema.rb"

PASS_THRESHOLD=5
score=0
results=()

fail() { results+=("❌  $1"); }
pass() { results+=("✅  $1"); score=$((score + 1)); }

echo "==> Assess started: $TICKET_PATH"

# ── Check 1: All 10 sections present and non-empty ──────────────────────────
missing=0
for section in \
  "## 1. Source" \
  "## 2. Business Rules" \
  "## 3. Acceptance Criteria" \
  "## 4. Domain Map" \
  "## 5. Technical Concerns" \
  "## 6. Constraints" \
  "## 7. File Targets" \
  "## 8. Insights" \
  "## 9. Assess Score" \
  "## 10. Amendments"
do
  if ! grep -qF "$section" "$CONTRACT"; then
    missing=$((missing + 1))
  fi
done

if [ "$missing" -eq 0 ]; then
  pass "All 10 sections present (Completeness)"
else
  fail "Missing $missing section(s) in contract.md (Completeness)"
fi

# ── Check 2: Business rules are not template placeholders ────────────────────
# Template content: "- Rule 1" / "- Rule 2"
if grep -qE "^- Rule [0-9]+$" "$CONTRACT"; then
  fail "Business rules contain template placeholders (Precision)"
elif ! grep -A5 "## 2. Business Rules" "$CONTRACT" | grep -qE "^- .+"; then
  fail "Business rules section is empty (Precision)"
else
  pass "Business rules are filled (Precision)"
fi

# ── Check 3: Acceptance criteria are testable (When/Then pattern) ────────────
if grep -qE "^- When X" "$CONTRACT"; then
  fail "Acceptance criteria contain template placeholders (Testability)"
elif ! grep -A10 "## 3. Acceptance Criteria" "$CONTRACT" | grep -qE "^- When .+then"; then
  fail "Acceptance criteria missing When/then assertions (Testability)"
else
  pass "Acceptance criteria follow When/then pattern (Testability)"
fi

# ── Check 4: Domain map references real tables from schema.rb ────────────────
if [ ! -f "$SCHEMA" ]; then
  fail "db/schema.rb not found — cannot verify domain map (Traceability)"
else
  # Extract table names mentioned in contract Domain Map section
  domain_tables=$(sed -n '/## 4. Domain Map/,/## 5./p' "$CONTRACT" | grep -oE '`[a-z_]+`' | tr -d '`' | sort -u)

  if [ -z "$domain_tables" ]; then
    fail "Domain map has no table references (Traceability)"
  else
    unknown=0
    while IFS= read -r table; do
      if ! grep -qE "create_table :$table|create_table \"$table\"" "$SCHEMA"; then
        unknown=$((unknown + 1))
      fi
    done <<< "$domain_tables"

    if [ "$unknown" -eq 0 ]; then
      pass "Domain map tables found in schema.rb (Traceability)"
    else
      fail "$unknown table(s) in domain map not found in schema.rb (Traceability)"
    fi
  fi
fi

# ── Check 5: Technical concerns section is non-template ─────────────────────
if grep -qE "^\- \*\*Concern\*\* —" "$CONTRACT"; then
  fail "Technical concerns contain template placeholder (Honesty)"
elif ! grep -A5 "## 5. Technical Concerns" "$CONTRACT" | grep -qE "^- \*\*.+\*\*"; then
  fail "Technical concerns section is empty (Honesty)"
else
  pass "Technical concerns are filled (Honesty)"
fi

# ── Check 6: File targets contain .rb paths ──────────────────────────────────
if ! sed -n '/## 7. File Targets/,/## 8./p' "$CONTRACT" | grep -qE "\.rb$"; then
  fail "File targets missing — no .rb paths listed (Precision)"
else
  pass "File targets contain .rb paths (Precision)"
fi

# ── Tasks check: spec + implementation files listed ─────────────────────────
tasks_ok=true
if ! grep -qE "spec/.*_spec\.rb" "$TASKS"; then
  echo "  [warn] tasks.md: no spec files listed"
  tasks_ok=false
fi
if ! grep -qE "\- \[ \] .+\.rb" "$TASKS"; then
  echo "  [warn] tasks.md: no implementation files listed"
  tasks_ok=false
fi

# ── Summary ──────────────────────────────────────────────────────────────────
echo ""
echo "  Contract score: $score/6"
for r in "${results[@]}"; do
  echo "    $r"
done

if ! $tasks_ok; then
  echo ""
  echo "  [warn] tasks.md is incomplete — human should review before advancing"
fi

echo ""

if [ "$score" -ge "$PASS_THRESHOLD" ]; then
  echo "==> PASS ($score/$PASS_THRESHOLD+ checks passed) — pipeline continues"
  exit 0
else
  echo "==> FAIL ($score/6 — threshold $PASS_THRESHOLD/6) — human review required"
  exit 1
fi
