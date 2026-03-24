---
name: manage-pr
description: |
  Creates or updates a pull request following project conventions. Use before pushing
  a branch for review or merging. Triggers on: "open PR", "create pull request",
  "ready for review", "submit PR", "open pull request", "update PR", "manage PR".
---

## Steps

1. Confirm all tests pass: `bundle exec rspec`
2. Confirm linting is clean: `bundle exec rubocop --autocorrect`
3. Stage and commit any outstanding changes
4. Push the current branch: `git push -u origin <branch>`
5. Use `mcp__github__list_pull_requests` to check if a PR already exists for this branch
   - If it exists: use `mcp__github__update_pull_request` with the PR number to update title and body
   - If it doesn't exist: use `mcp__github__create_pull_request` to open a new one
6. Link any related issues in the PR body

## Important
- Never use `gh` CLI or direct GitHub API calls — always use the `mcp__github__*` tools
- Always check for an existing PR before creating to avoid 422 errors

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
