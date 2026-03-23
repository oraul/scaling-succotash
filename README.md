# scaling-succotash

> **Harness Engineering challenge** — every line of code in this repository is written exclusively by Claude. No human-authored code.

A blog API built with Ruby, Sinatra, Sequel, and SQLite — used as a real-world proving ground for AI-driven development at scale.

## What is Harness Engineering?

Harness Engineering is a practice where AI agents (Claude) are the primary code authors. The repo is the agent's memory: CLAUDE.md sets the always-on rules, Skills package reusable workflows, and Commands give humans explicit control. The result is a codebase that grows through agent sessions without losing context or consistency.

This project follows those principles:
- `CLAUDE.md` — permanent rulebook injected at every session start
- `.claude/skills/` — on-demand workflow packages (migrations, PRs)
- `.claude/hooks/` — automation that runs at session boundaries
- `docs/` — living architecture docs kept up to date by the agent

## Features

- **Authentication** — token-based auth; only authenticated users can create articles
- **Articles** — create and list blog posts
- **Pagination** — list endpoint supports `page` and `per_page` query params
- **Filter by user** — list endpoint accepts a `user_id` param to scope articles

## Stack

- Ruby >= 3.3
- Sinatra (API)
- Sequel + SQLite (database)
- Async / Falcon (server)
- RSpec (tests)
- RuboCop (linter)

## Getting started

```bash
bundle install
rake db:migrate
bundle exec falcon host --bind http://0.0.0.0:3000
```

Or with Docker:

```bash
docker compose up --build
```

## API

### Auth

All write endpoints require the header:

```
Authorization: Bearer <token>
```

### Endpoints

#### System

| Method | Path      | Auth | Description  |
|--------|-----------|------|--------------|
| GET    | /health   | No   | Health check |

#### Users

| Method | Path         | Auth | Description                        |
|--------|--------------|------|------------------------------------|
| POST   | /users       | No   | Register — `{ name, email, password }` |
| GET    | /users/:id   | No   | Get a user's public profile        |

#### Auth

| Method | Path         | Auth | Description                              |
|--------|--------------|------|------------------------------------------|
| POST   | /sessions    | No   | Log in — `{ email, password }` → `{ token }` |
| DELETE | /sessions    | Yes  | Log out (invalidate token)               |

#### Articles

| Method | Path            | Auth | Description                                   |
|--------|-----------------|------|-----------------------------------------------|
| GET    | /articles       | No   | List articles (paginated, filterable by user) |
| GET    | /articles/:id   | No   | Get a single article                          |
| POST   | /articles       | Yes  | Create an article                             |
| PATCH  | /articles/:id   | Yes  | Update own article                            |
| DELETE | /articles/:id   | Yes  | Delete own article                            |

### List articles query params

```
GET /articles?page=1&per_page=20&user_id=42
```

| Param     | Default | Description                  |
|-----------|---------|------------------------------|
| page      | 1       | Page number                  |
| per_page  | 20      | Results per page (max 100)   |
| user_id   | —       | Filter articles by author    |

## Development

```bash
bundle exec rspec        # run tests
bundle exec rubocop      # lint
rake db:migrate          # run pending migrations
rake db:rollback         # rollback last migration
```
