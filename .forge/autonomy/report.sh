#!/usr/bin/env bash
# frozen_string_literal: true
# Autonomy report — shows Assess PASS/FAIL rates and Phase 2 readiness
# Usage: .forge/autonomy/report.sh

set -euo pipefail

LOG=".forge/autonomy/assess_log.csv"

if [ ! -f "$LOG" ]; then
  echo "No Assess runs logged yet — run the pipeline on a ticket first."
  exit 0
fi

total=$(tail -n +2 "$LOG" | wc -l | tr -d ' ')
passed=$(tail -n +2 "$LOG" | grep -c ",PASS," || true)
failed=$(tail -n +2 "$LOG" | grep -c ",FAIL," || true)

echo "==> Autonomy Report"
echo ""
echo "  Total Assess runs : $total"
echo "  PASS              : $passed"
echo "  FAIL              : $failed"

if [ "$total" -gt 0 ]; then
  rate=$(( passed * 100 / total ))
  echo "  PASS rate         : $rate%"
fi

# ── Consecutive PASSes (for threshold tightening decision) ───────────────────
consecutive=0
while IFS=',' read -r _ _ _ _ result _; do
  if [ "$result" = "PASS" ]; then
    consecutive=$((consecutive + 1))
  else
    consecutive=0
  fi
done < <(tail -n +2 "$LOG")

echo ""
echo "  Consecutive PASSes (current streak): $consecutive"

# ── Phase 2 readiness ────────────────────────────────────────────────────────
echo ""
echo "==> Phase 2 Readiness"
echo ""

check() {
  local label="$1"
  local met="$2"
  if [ "$met" = "true" ]; then
    echo "  ✅  $label"
  else
    echo "  ❌  $label"
  fi
}

# Criteria (see .forge/autonomy/phase2_criteria.md)
[ "$consecutive" -ge 10 ] && c1=true || c1=false
[ "$rate" -ge 80 ] 2>/dev/null && c2=true || c2=false
[ "$total" -ge 5 ] && c3=true || c3=false

check "10 consecutive Assess PASSes (current: $consecutive)"     "$c1"
check "Overall PASS rate ≥ 80% (current: ${rate:-0}%)"          "$c2"
check "At least 5 tickets run through Assess (current: $total)" "$c3"

echo ""
if [ "$c1" = "true" ] && [ "$c2" = "true" ] && [ "$c3" = "true" ]; then
  echo "  🚀 Ready for Phase 2 — raise threshold to 6/6 in blueprint.yml"
else
  echo "  Pipeline not yet ready for Phase 2 — keep running tickets."
fi
