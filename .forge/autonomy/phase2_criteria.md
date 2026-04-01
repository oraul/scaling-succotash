# Phase 2 Readiness Criteria

When to move from Claude CLI → Slack + AWS.

---

## Threshold Progression

Assess threshold starts at 5/6. Raise it as Compile quality is proven.

| Milestone | Action |
|---|---|
| 10 consecutive Assess PASSes | Raise threshold to 6/6 in `blueprint.yml` |
| 10 more consecutive PASSes at 6/6 | Compile is trusted — consider removing Assess gate |
| 3 Validate bails in last 20 tickets | Stop — Implement quality needs work before Phase 2 |

---

## Phase 2 Gates

All three must be true before starting Phase 2 work:

| Check | Threshold | How to measure |
|---|---|---|
| Consecutive Assess PASSes | ≥ 10 | `.forge/autonomy/report.sh` |
| Overall Assess PASS rate | ≥ 80% | `.forge/autonomy/report.sh` |
| Tickets run through pipeline | ≥ 5 | `.forge/autonomy/report.sh` |

Run `.forge/autonomy/report.sh` at any time to check current status.

---

## What Phase 2 Adds

- Slack invocation — trigger `.forge/run` from a Slack thread
- AWS warm spot instances — replace Claude CLI with cloud runtime
- Async gates — human approves via Slack reaction instead of terminal prompt

These are deferred until Phase 1 is stable and the criteria above are met.
