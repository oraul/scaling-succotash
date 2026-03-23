---
name: open-pr
description: |
  Opens a pull request following project conventions. Use before pushing
  a branch for review or merging. Triggers on: "open PR", "create pull request",
  "ready for review", "submit PR", "open pull request".
---

## Steps

1. Confirm all tests pass: `bundle exec rspec`
2. Confirm linting is clean: `bundle exec rubocop --autocorrect`
3. Stage and commit any outstanding changes
4. Push the current branch: `git push -u origin <branch>`
5. Open the PR with a title and body following the template below
6. Link any related issues in the PR body

## PR Title Format
```
<type>: <short imperative description>
```
Types: `feat`, `fix`, `refactor`, `docs`, `test`, `chore`

Example: `feat: add email column to users`

## PR Body Template
```markdown
## What
<!-- One sentence: what changed -->

## Why
<!-- One sentence: why it was needed -->

## How
<!-- Bullet list of key implementation decisions -->

## Testing
- [ ] bundle exec rspec passes
- [ ] bundle exec rubocop passes
- [ ] Manual smoke test (describe briefly)
```

## Never
- Never open a PR with failing tests
- Never open a PR with rubocop offenses that couldn't be auto-corrected
- Never push directly to main/master
