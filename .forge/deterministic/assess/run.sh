#!/usr/bin/env bash
# frozen_string_literal: true
# Assess — scores contract.md + tasks.md, outputs PASS/FAIL
# Usage: ./run.sh <ticket_path> [threshold]
# Example: ./run.sh docs/plans/active/FRG-0001-payment-retry 5
#
# Threshold passed from blueprint.yml — raise it as Compile quality is proven.
# FAIL → human gate (assess-edit or assess-reject)

set -euo pipefail

TICKET_PATH="${1:?Usage: run.sh <ticket_path>}"
CONTRACT="$TICKET_PATH/contract.md"
TASKS="$TICKET_PATH/tasks.md"
SCHEMA="db/schema.rb"
AUTONOMY_LOG=".forge/autonomy/assess_log.csv"

PASS_THRESHOLD="${2:-5}"
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

# ── Task familiarity: compare file target patterns against shipped tickets ───
# Informational only — does not affect score.
# Extracts path prefixes from File Targets and checks if shipped contracts
# have seen the same patterns before.
SHIPPED_DIR="docs/plans/shipped"
familiar_count=0
novel_patterns=()

# Extract path prefixes from File Targets section (lib/services/, lib/models/, db/migrate/, etc.)
mapfile -t target_patterns < <(
  sed -n '/## 7. File Targets/,/## 8./p' "$CONTRACT" \
    | grep -oE '(lib|spec|db)/[a-z_/]+' \
    | sed 's|/[^/]*$|/|' \
    | sort -u
)

if [ "${#target_patterns[@]}" -eq 0 ]; then
  familiarity_note="[familiarity] No path patterns found in File Targets — skipping"
elif [ ! -d "$SHIPPED_DIR" ] || [ -z "$(ls -A "$SHIPPED_DIR" 2>/dev/null)" ]; then
  familiarity_note="[familiarity] No shipped tickets yet — task type is novel by default"
else
  for pattern in "${target_patterns[@]}"; do
    if grep -rlE "$pattern" "$SHIPPED_DIR"/*/contract.md 2>/dev/null | grep -q .; then
      familiar_count=$((familiar_count + 1))
    else
      novel_patterns+=("$pattern")
    fi
  done

  if [ "${#novel_patterns[@]}" -eq 0 ]; then
    familiarity_note="[familiarity] All path patterns familiar — seen in $familiar_count shipped ticket(s)"
  else
    novel_list=$(IFS=", "; echo "${novel_patterns[*]}")
    familiarity_note="[familiarity] Novel patterns: $novel_list — no prior shipped examples"
  fi
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
echo "  $familiarity_note"
echo ""

# ── Autonomy log ─────────────────────────────────────────────────────────────
TICKET_NAME=$(basename "$TICKET_PATH")
DATE=$(date +%Y-%m-%d)
PATTERNS=$(sed -n '/## 7. File Targets/,/## 8./p' "$CONTRACT" \
  | grep -oE '(lib|spec|db)/[a-z_/]+' \
  | sed 's|/[^/]*$|/|' \
  | sort -u | tr '\n' '|' | sed 's/|$//')

if [ ! -f "$AUTONOMY_LOG" ]; then
  mkdir -p "$(dirname "$AUTONOMY_LOG")"
  echo "date,ticket,score,threshold,result,patterns" > "$AUTONOMY_LOG"
fi

if [ "$score" -ge "$PASS_THRESHOLD" ]; then
  echo "$DATE,$TICKET_NAME,$score,$PASS_THRESHOLD,PASS,$PATTERNS" >> "$AUTONOMY_LOG"
  echo "==> PASS ($score/$PASS_THRESHOLD+ checks passed) — pipeline continues"
  exit 0
else
  echo "$DATE,$TICKET_NAME,$score,$PASS_THRESHOLD,FAIL,$PATTERNS" >> "$AUTONOMY_LOG"
  echo "==> FAIL ($score/6 — threshold $PASS_THRESHOLD/6) — human review required"
  exit 1
fi
