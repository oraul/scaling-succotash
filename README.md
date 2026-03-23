# scaling-succotash

A blog API built with Ruby, Sinatra, Sequel, and SQLite.

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

| Method | Path            | Auth | Description                              |
|--------|-----------------|------|------------------------------------------|
| GET    | /health         | No   | Health check                             |
| POST   | /users          | No   | Register a new user                      |
| POST   | /sessions       | No   | Log in, returns token                    |
| POST   | /articles       | Yes  | Create an article                        |
| GET    | /articles       | No   | List articles (paginated, filterable)    |

### List articles

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
