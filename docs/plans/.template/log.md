# Log: FRG-XXXX — Short Description

Running record of human feedback during the pipeline run.
Contract, plan, and tasks are immutable — all feedback lives here.

## Entry Format

```
## [YYYY-MM-DD] [STEP] — [EVENT]
**Trigger:** what caused this entry
**Feedback:** what the human said or decided
**Action:** what the pipeline does next
```

### Events

| Event | Step | Trigger |
|---|---|---|
| `assess-edit` | Assess | Human edits contract or tasks at gate |
| `assess-reject` | Assess | Human rejects — pipeline ends |
| `validate-bail` | Validate | Failed after 2 attempts — human gives guidance |
| `pr-suggestions` | PR Review | Human leaves suggestions before approving |
| `pr-reject` | PR Review | Human rejects — pipeline ends |

---

<!-- entries below, newest last -->

## [YYYY-MM-DD] Assess — assess-edit
**Trigger:** Assess scored 4/6 — acceptance criteria not testable, file targets missing
**Feedback:** "Add the edge case for deleted users. Missing spec for PaymentAttempt model."
**Action:** Back to Compile → Plan → Assess

## [YYYY-MM-DD] Validate — validate-bail
**Trigger:** Validate failed attempt 2 — PaymentRetryService spec timeout error
**Feedback:** "The retry logic needs a mutex. Check existing PaymentProcessor for the pattern."
**Action:** Back to Draft with guidance

## [YYYY-MM-DD] PR Review — pr-suggestions
**Trigger:** Human reviewed PR and left suggestions
**Feedback:** "Extract the retry delay into a constant. Add a comment on the idempotency check."
**Action:** Back to Draft → Implement → Validate
